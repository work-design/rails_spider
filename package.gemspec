Gem::Specification.new do |s|
  s.name = 'rails_spider'
  s.version = '0.0.1'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_spider'
  s.summary = 'Summary of RailsSpider.'
  s.description = 'Description of RailsSpider.'
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'mechanize', '>= 2.7', '<= 2.8'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
