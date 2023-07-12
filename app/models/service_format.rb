class ServiceFormat < ApplicationRecord
  belongs_to :service
  has_many :service_cols, dependent: :destroy

  def feature(user_id)
    Feature.find_by(user_id: user_id, service_id: service_id)
  end

  def ver(user_id)
    Version.find_by(feature_id: self.feature(user_id), service_format_id: self.id)
  end
  # def version(user_id)
  #   feature = Feature.find_by(service_id: service_id, user_id: user_id)
  #   versions.find_by(feature_id: feature.id)
  # end
end
