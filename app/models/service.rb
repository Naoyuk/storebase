class Service < ApplicationRecord
  belongs_to :platform
  has_many :features, dependent: :destroy
  has_many :service_formats, dependent: :destroy
  has_many :mappings, through: :features

  validates :name, presence: true

  scope :order_by_platform, -> { joins(:platform).order('platforms.id ASC, id ASC') }
end
