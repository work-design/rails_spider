require 'the_spider/fetchers/mechanize'

module TheSpider
  class Resource
    attr_reader :fetcher

    def initialize(**options)
      @host = options[:host]
      @list_path = options[:list_path]
      @item_path = options[:item_path]
      @page_params = options[:page_params]
      @fetcher ||= TheSpider::Mechanize.new
    end

    def run
      save(item_path)
    end

    def save(url)
      body = fetcher.body(url)
      local = Local.find_or_initialize_by url: url
      local.body = body
      local.save
    end

    def list_path

    end

  end
end
