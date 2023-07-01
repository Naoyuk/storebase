require 'rails_helper'

RSpec.describe "Features", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }
  let(:feature) { FactoryBot.create(:feature, user: user) }

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
    FactoryBot.create(:feature, service: service1_p2, user_id: user.id)
    FactoryBot.create(:feature, service: service2_p1, user_id: user.id)
    FactoryBot.create(:feature, service: service3_p1, user_id: user.id)
    FactoryBot.create(:feature, service: service4_p2, user_id: user.id)

    visit features_path
    expect(page.text).to match %r{#{service2_p1.name}.*#{service3_p1.name}.*#{service1_p2.name}.*#{service4_p2.name}}
    expect(page.text).not_to match %r{#{service3_p1.name}.*#{service2_p1.name}.*#{service1_p2.name}.*#{service4_p2.name}}
    expect(page.text).not_to match %r{#{service1_p2.name}.*#{service3_p1.name}.*#{service2_p1.name}.*#{service4_p2.name}}
  end

  scenario 'platform name does not duplicate' do
    platform1 = FactoryBot.create(:platform)
    platform2 = FactoryBot.create(:platform)
    service = FactoryBot.create(:service, platform_id: platform1.id)
    FactoryBot.create(:feature, service_id: service.id, user_id: user.id)
    FactoryBot.create(:feature, service_id: service.id, user_id: user.id)
    FactoryBot.create(:feature, service_id: service.id, user_id: user.id)

    visit features_path
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

  describe "Convert CSV" do
    scenario "converts the uploaded csv file and downloads the converted file" do
      feature = FactoryBot.create(:feature, user: user)
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
