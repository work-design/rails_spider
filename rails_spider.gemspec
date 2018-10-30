$:.push File.expand_path('lib', __dir__)
require 'rails_spider/version'

Gem::Specification.new do |s|
  s.name = 'rails_spider'
  s.version = RailsSpider::VERSION
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/yougexiangfa/rails_spider'
  s.summary = 'Summary of RailsSpider.'
  s.description = 'Description of RailsSpider.'
  s.license = 'LGPL-3.0'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails', '>= 5.0', '<= 6.0'
  s.add_dependency 'mechanize', '>= 2.7', '<= 2.8'
  s.add_dependency 'kimurai', '>= 1.2', '<= 2.0'
  s.add_dependency 'rails_com', '~> 1.2'

  s.add_development_dependency 'sqlite3', '~> 1.3'
end
