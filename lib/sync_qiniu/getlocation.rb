#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
require 'net/http'
Bundler.require

Mongoid.load!("./config/mongoid.yml","development")

Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |m|
  require m
end

@events = Event.where(:source.ne => "douban") # can not use only because of update attribute

@events.each do |e|
  puts "ID: #{e.id}"
  puts e.place
  url = URI.escape("http://api.map.baidu.com/geocoder/v2/?address=#{e.place}&output=json&ak=A38d59da730152d77b407446a3c0dd2b")
  # Geocoding API:  http://developer.baidu.com/map/webservice-geocoding.htm
  # http://api.map.baidu.com/geocoder/v2/?address=%E5%BE%90%E5%AE%B6%E6%B1%87&output=json&ak=A38d59da730152d77b407446a3c0dd2b&callback=showLocation
  begin
    response = Net::HTTP.get_response(URI(url))
    puts response.body
    data = response.body
  rescue SocketError
    sleep 10
    retry
  end
    result = JSON.parse(data)
    puts result
  # status 说明文档:  http://developer.baidu.com/map/webservice-geocoding.htm#.E6.8E.A5.E5.8F.A3.E7.A4.BA.E4.BE.8A
  if result["status"] != 0
    e.location = [0.0, 0.0]
    e.save
    puts "This place can not translate to location......"
  else
    # {"status"=>0, "result"=>{"location"=>{"lng"=>121.48026424818, "lat"=>31.229092805768}, "precise"=>1, "confidence"=>80, "level"=>"道路"}}
    puts result["result"]["location"]
    store_result = []
    store_result << result["result"]["location"]["lng"]
    store_result << result["result"]["location"]["lat"]
    puts store_result
    e.location = store_result
    e.save
    puts "save location #{store_result} of ID: #{e.id} success!"
    puts '--------------------'
  end
end