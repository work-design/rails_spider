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

FileUtils.mkdir_p("log")
logger = Logger.new("log/getimage_log.txt")

@events = Event

logger.log(1, 'Prepare folder')
dir = "images/faces/#{Date.today.to_s.gsub("-", "_")}"
log =  "Try to make dir #{dir}"
logger.log(1, log)
FileUtils.mkdir_p(dir)

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