class Feature < ApplicationRecord
  belongs_to :user
  belongs_to :service
  has_many :versions, dependent: :destroy

  scope :order_by_platform, -> {
    joins(service: :platform).order('platforms.id')
  }

  def convert_csv(input_file_path)
    output_file_path = Rails.root.join('tmp', "#{user.id}_output.csv")
    mappings = current_version.mappings.default_order
    converter = CsvConverter.new(input_file_path, mappings)
    converter.convert_csv(output_file_path)
    if converter.errors.empty?
      [true, output_file_path]
    else
      [false, converter.errors]
    end
  end

  def current_version
    versions.find_by(current: true)
  end

  delegate :mappings, to: :current_version
  # def mappings
  #   current_version.mappings
  # end

  delegate :service_formats, to: :service
  # def service_formats
  #   service.service_formats
  # end

  def service_format
    service_formats.find_by(current: true)
  end

  delegate :name, to: :service, prefix: true
end
