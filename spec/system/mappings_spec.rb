require 'rails_helper'

RSpec.describe "Mappings", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario 'user creates a mapping' do
    feature = FactoryBot.create(:feature, user_id: user.id)
    service_format = FactoryBot.create(:service_format, service: feature.service)
    service_col1 = FactoryBot.create(:service_col, service_format: service_format)
    service_col2 = FactoryBot.create(:service_col, service_format: service_format)
    service_col3 = FactoryBot.create(:service_col, service_format: service_format)
    service_col4 = FactoryBot.create(:service_col, service_format: service_format)

    visit feature_path(feature)

    expect {
      click_link 'Show Mappings'
    }.to change(Mapping, :count).by(4).and change(Version, :count).by(1)

    expect(page).to have_content service_col1.ec_column
    expect(page).to have_content service_col1.data_type
    expect(page).to have_content service_col2.ec_column
    expect(page).to have_content service_col2.data_type
    expect(page).to have_content service_col3.ec_column
    expect(page).to have_content service_col3.data_type
    expect(page).to have_content service_col4.ec_column
    expect(page).to have_content service_col4.data_type
  end
end
