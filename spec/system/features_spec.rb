require 'rails_helper'

RSpec.describe "Features", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario 'user has own features' do
    feature1 = FactoryBot.create(:feature, user_id: user.id)
    feature2 = FactoryBot.create(:feature, user_id: user.id)
    feature3 = FactoryBot.create(:feature, user_id: another_user.id)
    feature4 = FactoryBot.create(:feature, user_id: another_user.id)

    visit root_path
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
    platform1 = FactoryBot.create(:platform)
    platform2 = FactoryBot.create(:platform)
    service = FactoryBot.create(:service, platform_id: platform1.id)
    FactoryBot.create(:feature, service_id: service.id, user_id: user.id)
    FactoryBot.create(:feature, service_id: service.id, user_id: user.id)
    FactoryBot.create(:feature, service_id: service.id, user_id: user.id)

    visit root_path
    within '#sidebarMenu' do
      expect(page).to have_content(platform1.name, count: 1)
      expect(page).not_to have_content platform2.name
    end
  end

  scenario 'user can see all mappings in a feature detail page' do
    feature1 = FactoryBot.create(:feature, user_id: user.id)
    feature2 = FactoryBot.create(:feature, user_id: user.id)
    mapping1 = FactoryBot.create(:mapping, feature_id: feature1.id)
    mapping2 = FactoryBot.create(:mapping, feature_id: feature2.id)
    mapping3 = FactoryBot.create(:mapping, feature_id: feature1.id)

    visit feature_path(feature1)
    within '.feature-title' do
      expect(page).to have_content(mapping1.feature.service.name, count: 1)
      expect(page).to have_content(mapping3.feature.service.name, count: 1)
      expect(page).not_to have_content(mapping2.feature.service.name)
    end

    expect(page).to have_content(mapping1.user_column)
    expect(page).to have_content(mapping1.ec_column)
    expect(page).to have_content(mapping3.user_column)
    expect(page).to have_content(mapping3.ec_column)
    expect(page).not_to have_content(mapping2.user_column)
    expect(page).not_to have_content(mapping2.ec_column)
  end
end
