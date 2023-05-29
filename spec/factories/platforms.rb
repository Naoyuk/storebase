FactoryBot.define do
  factory :platform do
    sequence(:name) { |n| "test#{n} platform" }
  end
end
