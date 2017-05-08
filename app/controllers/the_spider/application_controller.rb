module TheSpider
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    default_form_builder 'TheSpiderBuilder' do |config|

    end

  end
end
