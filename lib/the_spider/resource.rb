require 'the_spider/fetchers/mechanize'

module TheSpider
  class Resource
    attr_reader :fetcher, :host, :item_path, :list_path, :page_params
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
      get_items.each do |item|
        save(item)
      end
    end

    def get_items
      fetcher.links(list_url).select { |link| item_exp.match? link }
    end

    def save(url)
      body = fetcher.body(url)
      local = Local.find_or_initialize_by url: url
      local.body = body
      local.save
    end

    def list_url
      URI.join host, list_path
    end

    def item_exp
      Regexp.new(item_path.gsub SYMBOL_EXP, DEFAULT_EXP)
    end

  end
end
