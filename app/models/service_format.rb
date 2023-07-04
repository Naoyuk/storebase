class ServiceFormat < ApplicationRecord
  belongs_to :service
  has_many :service_cols, dependent: :destroy
end
