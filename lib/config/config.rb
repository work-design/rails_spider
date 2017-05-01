require 'json'
module EventSpider

  def self.configure
    yield @config ||= EventSpider::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :cities,
                    :event_class
  end

  configure do |config|
    config.cities = ['上海', '北京', '深圳']
    config.event_class = 'Event'
  end

  #config_path = File.expand_path('../config', __FILE__)
  #PROXY = JSON.load("#{config_path}/proxy.json")


end