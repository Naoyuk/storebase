FactoryBot.define do
  factory :service do
    name { "test service" }
    association :platform
  end
end
