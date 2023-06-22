class Service < ApplicationRecord
  belongs_to :platform
  has_many :features, dependent: :destroy
  has_many :mappings, through: :features

  validates :name, presence: true
end
