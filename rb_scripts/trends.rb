require 'rubygems'
require 'hpricot'
require 'rest-open-uri'

hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
my_html = ""
open("http://www.google.com/trends/hottrends", hdrs).each {|s| my_html << s}
@web_doc= Hpricot(my_html)

@t = []
(@web_doc/"td.hotColumn").search("a").each do |e|
  @t.push(e.inner_html)
end

puts @t