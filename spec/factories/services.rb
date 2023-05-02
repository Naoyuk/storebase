FactoryBot.define do
  factory :service do
    sequence(:name) { |n| "test#{n} service" }
    sequence(:url) { |n| "test#{n} url" }
    sequence(:icon) { |n| "test#{n} icon" }
    association :platform
  end
end
