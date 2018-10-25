module RailsSpider
  class Cookie < ApplicationRecord
    attribute :name, type: String
    attribute :password, type: String
    attribute :domain, type: String
    attribute :value, type: String

  end
end
