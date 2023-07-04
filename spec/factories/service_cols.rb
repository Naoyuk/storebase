FactoryBot.define do
  factory :service_col do
    sequence(:ec_column) { |n| "test_ec_col#{n}" }
    data_type { :integer }
    association :service_format
  end
end
