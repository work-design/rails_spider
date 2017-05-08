require 'the_spider/fetchers/mechanize'

module TheSpider
  class Resource

    def initialize(list, page = 'page', item)
      @list = list
      @page = page
      @item = item
      @fetcher ||= TheSpider::Mechanize.new
    end

    def run

    end

    def save

    end


  end
end
