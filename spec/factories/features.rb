FactoryBot.define do
  factory :feature do
    sequence(:name) { |n| "test feature#{n}" }
    association :user
  end
end
