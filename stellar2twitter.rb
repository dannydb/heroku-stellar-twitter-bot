require 'open-uri'
require 'json'
require 'twitter'
require 'oembed'

Twitter.configure do |c|
  c.consumer_key = ENV["CONSUMER_KEY"]
  c.consumer_secret = ENV["CONSUMER_SECRET"]
  c.oauth_token = ENV["OAUTH_TOKEN"]
  c.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

feed_url = "http://stellar.io/#{ENV["USERNAME"]}/flow/json"

OEmbed::Providers.register_all
client = Twitter::Client.new
feed = JSON.parse(open(feed_url).read)

feed['items'].each do |item|
  url = item['item_url']
  favecount = item['favedby_entities'].length
  next if favecount < 2

  begin
    if url.match(/twitter.com\/.*\/status\/(.*)$/)
      client.retweet($1)
    end
  rescue Exception => e
    puts "Oh well: #{e}"
  end
end
