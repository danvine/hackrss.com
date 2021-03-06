# Yes, this should be a gem..

require 'cgi' unless defined?(CGI)
require 'digest' unless defined?(Digest)
 
class Url2png
  attr_reader :apikey, :secret, :query_string, :token, :base, :alt, :target
  def initialize options
 
    @apikey = ENV['URL2PNG_APIKEY']
    @secret = ENV['URL2PNG_SECRET']
 
    @target = options[:url]
    @base = options[:base] || "130.211.8.147"

    options.delete(:base) rescue nil

    @alt = options[:alt] || nil
    options.delete(:alt) rescue nil


    @query_string = options.sort.map { |k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join("&")
    @token = Digest::MD5.hexdigest(query_string + secret)


  end
 
 def to_s
  self.url
end

  def url
    "#{self.base}/v6/#{apikey}/#{token}/png/?#{query_string}"
  end
 
  def img
    "<img src='http://#{self.url}' class='ss' title='#{self.alt.to_s.gsub('\'','')}' data-url='#{self.target}' />"
  end

end
 
# Usage
# options = {
#   url: "http://www.wearebox.com/test/audioneday/editorial.php?i=9697869",
#   viewport: "1024x1024",
#   fullpage: true
# }
# puts Url2png.new(options).url

