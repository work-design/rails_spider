class SpiderSession < ApplicationRecord
  attribute :name, :string
  attribute :password, :string
  attribute :domain, :string
  attribute :value, :string

end
