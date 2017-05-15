module TheSpider
  class Local < ApplicationRecord



    def parser
      @parser ||= Parser.new(self.body)
    end

  end
end
