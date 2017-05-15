module TheSpider
  class Parser
    attr_accessor :doc

    def initialize(body)
      @doc = Nokogiri::HTML(body)
    end

  end
end
