FactoryBot.define do
  factory :service_format do
    version { "1" }
    active { true }
    current { true }
    association :service
  end
end
