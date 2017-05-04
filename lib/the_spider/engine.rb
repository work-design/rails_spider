module TheSpider
  class Engine < ::Rails::Engine
    isolate_namespace TheSpider

    initializer 'the_spider.assets.precompile' do |app|
      app.config.assets.precompile += ['the_spider_manifest.js']
    end
  end
end
