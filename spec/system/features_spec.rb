require 'rails_helper'

RSpec.describe "Features", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }
  # let(:service) { FactoryBot.create(:service) }
  # let(:service_format) { FactoryBot.create(:service_format, service: service) }
  # let(:feature) { FactoryBot.create(:feature, user: user, service: service) }

  before do
    driven_by(:rack_test)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario 'user has own features' do
    service = FactoryBot.create(:service)
    another_service = FactoryBot.create(:another_service)
    service_format = FactoryBot.create(:service_format, service: service)
    feature1 = FactoryBot.create(:feature, user: user, service: service)
    feature2 = FactoryBot.create(:feature, user: user, service: service)
    feature3 = FactoryBot.create(:feature, user: another_user, service: another_service)
    feature4 = FactoryBot.create(:feature, user: another_user, service: another_service)

    visit features_path
    expect(page).to have_content feature1.service.platform.name
    expect(page).to have_content feature2.service.platform.name
    expect(page).to have_content feature1.service.name
    expect(page).to have_content feature2.service.name
    expect(page).not_to have_content feature3.service.platform.name
    expect(page).not_to have_content feature4.service.platform.name
    expect(page).not_to have_content feature3.service.name
    expect(page).not_to have_content feature4.service.name
  end

  scenario 'features are sorted by platforms' do
    platform1 = FactoryBot.create(:platform)
    platform2 = FactoryBot.create(:platform)
    service1_p2 = FactoryBot.create(:service, platform: platform2)
    service2_p1 = FactoryBot.create(:service, platform: platform1)
    service3_p1 = FactoryBot.create(:service, platform: platform1)
    service4_p2 = FactoryBot.create(:service, platform: platform2)
    FactoryBot.create(:service_format, service: service1_p2)
    FactoryBot.create(:service_format, service: service2_p1)
    FactoryBot.create(:service_format, service: service3_p1)
    FactoryBot.create(:service_format, service: service4_p2)
    FactoryBot.create(:feature, service: service1_p2, user: user)
    FactoryBot.create(:feature, service: service2_p1, user: user)
    FactoryBot.create(:feature, service: service3_p1, user: user)
    FactoryBot.create(:feature, service: service4_p2, user: user)

    visit features_path
    service_names_on_page = all('.service-name').map(&:text)
    expected_order = [service2_p1, service3_p1, service1_p2, service4_p2].map(&:name)
    inexpected_order1 = [service3_p1, service2_p1, service1_p2, service4_p2].map(&:name)
    inexpected_order2 = [service1_p2, service3_p1, service2_p1, service4_p2].map(&:name)

    expect(service_names_on_page).to eq(expected_order)
    expect(service_names_on_page).not_to eq(inexpected_order1)
    expect(service_names_on_page).not_to eq(inexpected_order2)
  end

  scenario 'platform name does not duplicate' do
    skip 'サイドバーを表示するのをやめたけど、将来復活した時のために一旦スキップ'
    platform1 = FactoryBot.create(:platform)
    platform2 = FactoryBot.create(:platform)
    service = FactoryBot.create(:service, platform_id: platform1.id)
    FactoryBot.create(:service_format, service: service)
    FactoryBot.create(:feature, service_id: service.id, user: user)
    FactoryBot.create(:feature, service_id: service.id, user: user)
    FactoryBot.create(:feature, service_id: service.id, user: user)

    visit features_path
    within '#sidebarMenu' do
      expect(page).to have_content(platform1.name, count: 1)
      expect(page).not_to have_content platform2.name
    end
  end

  scenario 'user can see all mappings in a feature detail page' do
    feature1 = FactoryBot.create(:feature, user: user)
    feature2 = FactoryBot.create(:feature, user: user)
    service_format = FactoryBot.create(:service_format)
    version1 = FactoryBot.create(:version, service_format: service_format, feature: feature1, current: true)
    version2 = FactoryBot.create(:version, service_format: service_format, feature: feature2, current: true)
    mapping1 = FactoryBot.create(:mapping, version: version1)
    mapping2 = FactoryBot.create(:mapping, version: version2)
    mapping3 = FactoryBot.create(:mapping, version: version1)

    visit feature_mappings_path(feature1.id)
    within '.feature-title' do
      expect(page).to have_content(mapping1.version.feature.service.name, count: 1)
      expect(page).to have_content(mapping3.version.feature.service.name, count: 1)
      expect(page).not_to have_content(mapping2.version.feature.service.name)
    end

    expect(page).to have_content(mapping1.user_column)
    expect(page).to have_content(mapping1.ec_column)
    expect(page).to have_content(mapping3.user_column)
    expect(page).to have_content(mapping3.ec_column)
    expect(page).not_to have_content(mapping2.user_column)
    expect(page).not_to have_content(mapping2.ec_column)
  end

  describe "Convert CSV" do
    scenario "converts the uploaded csv file and downloads the converted file" do
      feature = FactoryBot.create(:feature, user: user)
      service_format = FactoryBot.create(:service_format, service: feature.service)
      version = Version.create(feature: feature, current: true, service_format: service_format)
      version.mappings.create(user_column: 'item_number', ec_column: 'Handle')
      version.mappings.create(user_column: 'item_name', ec_column: 'Title')
      version.mappings.create(user_column: 'price', ec_column: 'Variant Price')

      visit converter_path
      select feature.service_name, from: 'feature_id'
      attach_file("csv_file", 'spec/fixtures/files/input.csv')
      click_button "Convert"

      expect(page.response_headers['Content-Disposition']).to include("attachment; filename=\"output.csv\"")
    end

    scenario "raise error when a user doesn't choose a Feature with select box" do
      # ログインユーザーのFeatureが1つでもあるとformのactionにそのidがセットされるので、わざと別のユーザーのFeatureとして作成（Featureの作成自体しなくても可）
      FactoryBot.create(:feature, user: another_user)
      visit converter_path
      attach_file("csv_file", 'spec/fixtures/files/input.csv')
      click_button "Convert"

      expect(page).to have_content 'Please choose a target service.'
    end

    scenario "raise error when a user doesn't set an upload file" do
      feature = FactoryBot.create(:feature, user: user)
      visit converter_path
      select feature.service_name, from: 'feature_id'
      click_button "Convert"

      expect(page).to have_content 'Please upload a csv file.'
    end
  end
end
