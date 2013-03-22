require 'open-uri'
require 'rss/atom'
require 'twitter'
require 'oembed'

Twitter.configure do |c|
  c.consumer_key = ENV["CONSUMER_KEY"]
  c.consumer_secret = ENV["CONSUMER_SECRET"]
  c.oauth_token = ENV["OAUTH_TOKEN"]
  c.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

feed_url = "http://stellar.io/#{ENV["USERNAME"]}/flow/feed"

OEmbed::Providers.register_all
client = Twitter::Client.new
feed = RSS::Parser.parse(open(feed_url))

feed.items.each do |item|
  url = item.link.href
  begin
    if url.match(/twitter.com\/.*\/status\/(.*)$/)
      client.retweet($1)
    else
      info = OEmbed::Providers.get(url)
      url = info.web_page_short_url unless info.provider_name != "Flickr"
      client.update("#{info.author_name}: #{url}")
    end
  rescue Exception => e
    puts "Oh well: #{e}"
  end
end
