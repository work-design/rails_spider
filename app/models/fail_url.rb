class FailUrl < ApplicationRecord
  attribute :url, type: String
  attribute :source, type: String
  attribute :flag, type: String

end
