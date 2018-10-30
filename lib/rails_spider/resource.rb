
module RailsSpider
  class Resource
    attr_reader :fetcher, :work, :host, :item_path, :list_path, :page_params
    attr_accessor :page
    DEFAULT_EXP = "([^\/.?]+)"
    SYMBOL_EXP = /:\w+/

    def initialize(work, **options)
      @work = work
      @host = work.host
      @list_path = work.list_path
      @item_path = work.item_path
      @page_params = work.page_params
      @page = 1
      @fetcher ||= RailsSpider::Mechanize.new
    end

    def run
      items = get_items

      while items.size > 0 do
        items.each do |item|
          save(item)
        end
        self.page += 1
        items = get_items
      end
    end

    def get_items
      fetcher.links(list_url).select { |link| item_exp.match? link }
    end

    def save(url)
      body = fetcher.body(url)
      local = Local.find_or_initialize_by url: url, work_id: work.id
      local.body = body
      local.save
    end

    def list_url
      list_url = URI.join host, list_path
      if page.to_i > 0
        page_query = URI.encode_www_form page_params => page
        list_url.query = page_query
      end

      list_url
    end

    def item_exp
      Regexp.new(item_path.gsub SYMBOL_EXP, DEFAULT_EXP)
    end

  end
end
