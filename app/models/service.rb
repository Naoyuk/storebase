class Service < ApplicationRecord
  belongs_to :platform

  validates :name, presence: true
end
