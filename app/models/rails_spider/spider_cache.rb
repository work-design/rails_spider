class SpiderCache < ApplicationRecord
  belongs_to :spider_work

  def parser
    @parser ||= work.parser.new(self.body)
  end

  def run

  end

end
