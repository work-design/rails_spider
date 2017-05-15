module TheSpider
  class Local < ApplicationRecord
    belongs_to :work


    def parser
      @parser ||= Parser.new(self.body)
    end

  end
end
