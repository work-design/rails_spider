module TheSpider
  class Parser
    attr_accessor :doc

    def initialize(body)
      @doc = Nokogiri::HTML(body)
    end

    def save
      raise 'Should implement in subclass'
    end

  end
end
