require 'bundler'
Bundler.require
require 'open-uri'
require 'rss/atom'

config = YAML.load(open("config.yml"))
Twitter.configure do |c|
  c.consumer_key = config["CONSUMER_KEY"]
  c.consumer_secret = config["CONSUMER_SECRET"]
  c.oauth_token = config["OAUTH_TOKEN"]
  c.oauth_token_secret = config["OAUTH_TOKEN_SECRET"]
end

user = config["USERNAME"]
feed_url = "http://stellar.io/#{user}/flow/feed"

uri = URI.parse(ENV["REDISTOGO_URL"])
redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

OEmbed::Providers.register_all
client = Twitter::Client.new
feed = RSS::Parser.parse(open(feed_url))

feed.items.each do |item|
  url = item.link.href
  if !redis.sismember("stellar:#{user}:urls",url)
    redis.sadd("stellar:#{user}:urls",url)
    begin
      if url.match(/twitter.com\/.*\/status\/(.*)$/)
        client.retweet($1)
      else
        info = OEmbed::Providers.get(url)
        client.update("#{url} by #{info.author_name}: #{info.title}")
      end
    rescue Exception => e
      puts "Oh well: #{e}"
    end
  end
end
