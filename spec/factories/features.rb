FactoryBot.define do
  factory :feature do
    association :user
    association :service
  end
end
