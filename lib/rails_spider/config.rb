require 'active_support/configurable'

module RailsSpider #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.app_class = 'ApplicationController'
    config.my_class = 'MyController'
    config.admin_class = 'AdminController'
    config.api_class = 'ApiController'
    config.disabled_models = []
  end

end


