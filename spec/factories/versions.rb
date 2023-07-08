FactoryBot.define do
  factory :version do
    current { true }
    association :feature
  end
end
