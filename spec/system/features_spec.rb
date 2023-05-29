require 'rails_helper'

RSpec.describe "Features", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)

    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario 'user has own features' do
    feature1 = FactoryBot.create(:feature, user_id: user.id)
    feature2 = FactoryBot.create(:feature, user_id: user.id)
    feature3 = FactoryBot.create(:feature, user_id: another_user.id)
    feature4 = FactoryBot.create(:feature, user_id: another_user.id)

    visit '/dashboard'
    expect(page).to have_content feature1.service.platform.name
    expect(page).to have_content feature2.service.platform.name
    expect(page).to have_content feature1.service.name
    expect(page).to have_content feature2.service.name
    expect(page).not_to have_content feature3.service.platform.name
    expect(page).not_to have_content feature4.service.platform.name
    expect(page).not_to have_content feature3.service.name
    expect(page).not_to have_content feature4.service.name
  end

  scenario 'platform name does not duplicate' do
    platform1 = FactoryBot.create(:platform, name: 'platform1')
    platform2 = FactoryBot.create(:platform, name: 'platform2')
    service = FactoryBot.create(:service, platform_id: platform1.id)
    feature1 = FactoryBot.create(:feature, service_id: service.id, user_id: user.id)
    feature2 = FactoryBot.create(:feature, service_id: service.id, user_id: user.id)
    feature3 = FactoryBot.create(:feature, service_id: service.id, user_id: user.id)

    visit '/dashboard'
    expect(page).to have_content(platform1.name, count: 1)
    expect(page).not_to have_content platform2.name
  end
end
