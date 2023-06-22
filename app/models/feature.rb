class Feature < ApplicationRecord
  belongs_to :user
  belongs_to :service
  has_many :mappings, dependent: :destroy

  scope :order_by_platform, -> {
    joins(service: :platform).order('platforms.id')
  }
end
