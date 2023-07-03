class ServiceCol < ApplicationRecord
  belongs_to :service_format

  enum data_type: {
    string: 0,
    integer: 1,
    date: 2,
    time: 3,
    datetime: 4,
    bool: 5
  }
end
