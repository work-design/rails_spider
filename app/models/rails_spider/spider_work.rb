class SpiderWork < ApplicationRecord
  has_many :spider_caches, dependent: :delete_all
  has_many :spider_resources, dependent: :delete_all

  accepts_nested_attributes_for :spider_resources, allow_destroy: true, reject_if: :all_blank

  def spider
    @spider ||= ApplicationSpider.new
  end

  def run
    ApplicationSpider.crawl!
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
