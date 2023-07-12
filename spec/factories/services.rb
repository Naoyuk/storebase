FactoryBot.define do
  factory :service do
    sequence(:name) { |n| "test#{n} service" }
    sequence(:url) { |n| "test#{n} url" }
    sequence(:icon) { |n| "test#{n} icon" }
    association :platform
  end

  factory :another_service, class: Service do
    sequence(:name) { |n| "another#{n} service" }
    sequence(:url) { |n| "another#{n} url" }
    sequence(:icon) { |n| "another#{n} icon" }
    association :platform
  end
end
