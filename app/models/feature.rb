class Feature < ApplicationRecord
  belongs_to :user
  belongs_to :service
  has_many :mappings
end
