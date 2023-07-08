class Version < ApplicationRecord
  belongs_to :feature
  belongs_to :service_format
  has_many :mappings, dependent: :destroy

  validates :current, presence: true

  def save_with_mappings
    transaction do
      save!
      Mapping.create_by_version(self)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end
end
