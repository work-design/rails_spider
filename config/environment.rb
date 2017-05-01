require 'rubygems'
require 'bundler'
require 'logger'

Bundler.require
$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.expand_path('../../event_common', __FILE__)
$:.unshift File.expand_path('../../event_common/app', __FILE__)
$:.unshift File.expand_path('../../event_common/app/models', __FILE__)
$:.unshift File.expand_path('../../event_common/app/models/concerns', __FILE__)
$:.unshift File.expand_path('../../event_common/app/uploaders', __FILE__)


Mongoid.load!("./config/mongoid.yml", ENV['SPIDER_ENV'])

spider_root = File.expand_path '../..', __FILE__
# require models
Dir.glob("#{spider_root}/models/*.rb").each { |f| require f }

Dir.glob("#{spider_root}/proxy/*.rb").each {|f| require f}

# require spider
Dir.glob("#{spider_root}/lib/event_spider.rb").each { |f| require f }
