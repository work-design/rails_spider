module RailsSpider
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    default_form_builder 'RailsSpiderBuilder' do |config|

    end

  end
end
