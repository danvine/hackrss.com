require 'open-uri'
require 'pp'
require 'rack/cache'
require 'rss'
require 'sinatra'
require 'sinatra/base'
require 'memcachier'
require 'dalli'
require 'simple-rss'
require 'cgi'
require 'yaml'

require './lib/url2png'

class Hackrss < Sinatra::Base

  $cache = Dalli::Client.new

  # use Rack::Cache,
  #   :verbose => true,
  #   :metastore => $cache,
  #   :entitystore => $cache

  get "/" do
    cache_control :public, :max_age => 5 * 60

    @cached = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @rows = 5
    @session = session

    params[:unique] ||= 1

    @items = []
    url = params[:url]
    url ||= 'https://news.ycombinator.com/bigrss'
    # url = 'http://feeds.pinboard.in/rss/popular/?count=400'

    feed = SimpleRSS.parse open(url)
    feed.items.each do |item|

      url = CGI.unescapeHTML item.link rescue item.link

      item = {title: item.title, url: url, comments: item.comments}
      options = {
        url: url,
        viewport: "1024x600",
        thumbnail_max_width: 300,
        alt: item[:title],
        base: '130.211.8.147/',
        unique: (Time.now.to_i / 500)
      }

      puts options.to_yaml

      item[:ss] = Url2png.new(options).img
      @items << item

    end

    erb :home
  end
end
