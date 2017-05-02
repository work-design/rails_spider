module TheSpider
  class FailedUrl < ApplicationRecord
    attribute :url, type: String
    attribute :source, type: String
    attribute :flag, type: String
  end
end
