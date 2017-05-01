#!/usr/bin/env ruby
require 'rubygems'
require 'fileutils'
require 'open-uri'
require 'bundler'
Bundler.require

Mongoid.load!("./config/mongoid.yml","development")

Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |m|
  require m
end

group_len = 200
id = "534274765275627a63000000"
count = Event.where(poster_width: nil, :id.gt => id).count
while count > 100
  threads = []
  @events = Event.where(poster_width: nil, :id.gt => id).limit(1000).to_a
  @events.each_slice(group_len).each do |event_group|
    threads << Thread.new do
      event_group.each do |e|
        next if e.filename.blank?
        begin
          e.update_image_info
        rescue  => se
          log = "#{Time.now}\n#{se.message}\n#{se.backtrace}#{e.url}"
          puts log
        end
      end
    end
  end
  threads.map(&:join)
  id = @events.last.id.to_s
  count = Event.where(poster_width: nil, :id.gt => id).count
end

