module RailsSpider
  class Engine < ::Rails::Engine
    isolate_namespace RailsSpider

    initializer 'rails_spider.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_spider_manifest.js']
    end
  end
end
