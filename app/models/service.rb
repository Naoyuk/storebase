class Service < ApplicationRecord
  belongs_to :platform
  has_many :features, dependent: :destroy

  validates :name, presence: true
end
