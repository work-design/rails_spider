module TheSpider
  class Work < ApplicationRecord
    has_many :locals

    def resource
      @resource ||= Resource.new(self)
    end

    def run
      @resource.run
    end

    def parser
      @parser ||= self.parser_name.to_s.safe_constantize
    end

    def parse
      locals.each do |local|
        local.run
      end
    end

  end
end
