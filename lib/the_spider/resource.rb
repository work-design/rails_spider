require 'the_spider/fetchers/mechanize'

module TheSpider
  class Resource
    attr_reader :fetcher

    def initialize(list, page = 'page', item)
      @list = list
      @page = page
      @item = item
      @fetcher ||= TheSpider::Mechanize.new
    end

    def run
      save(@item)
    end

    def save(url)
      body = fetcher.body(url)
      local = Local.find_or_initialize_by url: url
      local.body = body
      local.save
    end

  end
end
