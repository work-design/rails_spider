#!/usr/bin/env ruby
require 'rubygems'
require 'fileutils'
require 'open-uri'
require 'bundler'
require 'logger'
Bundler.require

Mongoid.load!("./config/mongoid.yml","development")

Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |m|
  require m
end

Dir.glob("#{File.dirname(__FILE__)}/helper/*.rb").each do |h|
  require h
end

FileUtils.mkdir_p("log")
logger = Logger.new("log/getimage_log.txt")

@events = Event

logger.log(1, 'Prepare folder')
dir = "images/faces/#{Date.today.to_s.gsub("-", "_")}"
log =  "Try to make dir #{dir}"
logger.log(1, log)
FileUtils.mkdir_p(dir)

@events = @events.where(filename: nil)

count_to_download = @events.count

log = "Will download #{count_to_download} events face"
logger.log(1, log)

@events = @events.to_a

group_len = 800

threads = []

@events.each_slice(group_len).each do |event_group|
  threads << Thread.new do
    event_group.each do |e|
      begin
        data = open(URI.encode(e.face)){ |f| f.read }

        filetype = File.extname(e.face).gsub(/\?.*$/, "")
        filename = "face-" + e.id.to_s + filetype
        filename = "#{dir}/#{filename}"
        open(filename, "wb") { |f| f.write(data) }
        log = "Download #{filename} to images/..."
        logger.log(1, log)
        e.update_attribute(:filename, filename)
        sleep 0.5
      rescue => se
        log = "throw a exception:\n#{se.message}\n#{se.backtrace}\n#{e.url}"
        logger.log(1, log)
        sleep 1
      end
    end
  end
end

threads.map(&:join)

# sync to qiniu after download all images.
if count_to_download > 0
  pwd = File.dirname(File.expand_path('.', __FILE__))
  log =  "pwd #{pwd}"
  logger.log(1, log)
  config = "#{pwd}/config/qiniu_conf.json"
  qrsync = "#{pwd}/vendor/qiniu/qrsync"
  log = 'sync to qiniu after download all images.'
  logger.log(1, log)
  cmd = "#{qrsync} #{config}"
  logger.log(1, cmd)
  `#{cmd}`
end

threads = []
@events = Event.where(poster_width: nil).to_a
@events.each_slice(group_len).each do |event_group|
  threads << Thread.new do
    event_group.each do |e|
      next if e.filename.blank?
      begin
        e.update_image_info
      rescue  => se
        log = "#{Time.now}\n#{se.message}\n#{se.backtrace}#{e.url}"
        logger.log(1, log)
      end
    end
  end
end

threads.map(&:join)
