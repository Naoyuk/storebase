class Mapping < ApplicationRecord
  belongs_to :version

  enum data_type: {
    string: 0,
    integer: 1,
    date: 2,
    time: 3,
    datetime: 4,
    bool: 5
  }

  scope :default_order, -> {
    order('id ASC')
  }

  def self.create_by_version(version)
    version.service_format.service_cols.each do |col|
      version.mappings.create!(ec_column: col.ec_column, data_type: col.data_type)
    end
  end
end
