require 'the_spider/fetchers/mechanize'

module TheSpider
  class Resource
    attr_reader :fetcher, :item_path, :list_path, :page_params
    DEFAULT_EXP = "([^\/.?]+)"
    SYMBOL_EXP = /:\w+/

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

    def dry_run
      list_path
      fetcher.links()
    end

    def save(url)
      body = fetcher.body(url)
      local = Local.find_or_initialize_by url: url
      local.body = body
      local.save
    end

    def list_url
      
    end

    def item_exp
      Regexp.new(item_path.gsub SYMBOL_EXP, DEFAULT_EXP)
    end

  end
end
