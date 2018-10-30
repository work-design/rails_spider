class SpiderFail < ApplicationRecord
  attribute :url, :string
  attribute :source, :string
  attribute :flag, :string

  belongs_to :spider_work


end
