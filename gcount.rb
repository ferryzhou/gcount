# encoding: UTF-8

require 'open-uri'
require 'net/http'
require 'uri'
require 'nokogiri'

# example: https://www.google.com/search?q="连线：谷歌或成亚马逊最大拦路虎“
def query_google(str)
  query_link = "https://www.google.com/search?q='#{URI.escape(str)}'"
  p query_link
  content = open(query_link).read
  #p content
  doc = Nokogiri::HTML(content)
  r = doc.css('#resultStats')
  ss = r.text.split(' ')
  ss[1].gsub(',','').to_i
end

str = '连线：谷歌或成亚马逊最大拦路虎'
p query_google(str)