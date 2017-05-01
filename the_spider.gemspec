$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "the_spider/version"

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

  s.add_dependency "rails", "~> 5.1.0.rc1"

  s.add_development_dependency "sqlite3"
end
