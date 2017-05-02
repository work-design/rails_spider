module TheSpider
  class Resource

    def initialize(index, page)
      @page = ''
    end

    def event_class
      @event_class = EventSpider.config.event_class.constantize
    end

  end
end
