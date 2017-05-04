$:.push File.expand_path("../lib", __FILE__)
require 'the_spider/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "the_spider"
  s.version     = TheSpider::VERSION
  s.authors     = ["qinmingyuan"]
  s.email       = ["mingyuan0715@foxmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of TheSpider."
  s.description = "Description of TheSpider."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '>= 5.0'
  s.add_dependency 'mechanize', '>= 2.7'
  s.add_dependency 'watir', '>= 6.2.0'
end
