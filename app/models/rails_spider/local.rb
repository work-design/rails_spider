module RailsSpider
  class Local < ApplicationRecord
    belongs_to :work

    def parser
      @parser ||= work.parser.new(self.body)
    end

    def run

    end

  end
end
