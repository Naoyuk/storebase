FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:user_name) { |n| "test#{n}" }
    sequence(:first_name) { |n| "test#{n}first" }
    sequence(:last_name) { |n| "test#{n}last" }
    sequence(:company_name) { |n| "test#{n}company" }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user1.png')) }
    password { 'password' }
  end
end
