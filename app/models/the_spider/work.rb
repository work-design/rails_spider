module TheSpider
  class Work < ApplicationRecord

    def resource
      @resource ||= Resource.new(self)
    end

    def run
      @resource.run
    end

    def parser
      @parser ||= self.parser_name.to_s.safe_constantize
    end

  end
end
