require 'open-uri'
require 'pp'
require 'rack/cache'
require 'rss'
require 'memcachier'
require 'dalli'
require 'simple-rss'

require './lib/url2png'

@items = []
url = 'https://news.ycombinator.com/bigrss'
feed = SimpleRSS.parse open(url)

feed.items.each do |item|

  puts item.keys
  puts ""
  puts item.link
  puts URI.unescape item.link
  puts CGI.unescapeHTML item.link
  puts ""

  puts ""


# item = {title: item.title, url: item.link, comments: item.comments}
# options = {
# url: URI.unescape(item.link),
# viewport: "1024x600",
# fullpage: false,
# thumbnail_max_width: 300,
# alt: item[:title]
# }

# item[:ss] = Url2png.new(options).img
# item[:ss2] = Url2png.new(options)
# @items << item

end
