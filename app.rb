require 'open-uri'
require 'pp'
require 'rack/cache'
require 'rss'
require 'sinatra'
require 'sinatra/base'
require 'memcachier'
require 'dalli'

require './lib/url2png'

class Hackrss < Sinatra::Base

  $cache = Dalli::Client.new

  use Rack::Cache,
    :verbose => true,
    :metastore => $cache,
    :entitystore => $cache

  get "/" do
    cache_control :public, :max_age => 5 * 60

    @cached = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @rows = 5
    @session = session
    
    @items = []
    url = 'https://news.ycombinator.com/bigrss'
    url = 'http://feeds.pinboard.in/text/popular/?count=100'
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|

        item = {title: item.title, url: item.link, comments: item.comments}

        options = {
          url: item[:url],
          viewport: "1024x600",
          fullpage: false,
          thumbnail_max_width: 300,
          alt: item[:title]
        }

        item[:ss] = Url2png.new(options).img

        @items << item
      end
    end
    erb :home
  end
end
