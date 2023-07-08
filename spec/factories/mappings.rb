FactoryBot.define do
  factory :mapping do
    sequence(:user_column) { |n| "test_user_col#{n}" }
    sequence(:ec_column) { |n| "test_ec_col#{n}" }
    data_type { :integer }
    association :version
  end
end
