require 'rails_helper'

RSpec.describe "Mappings", type: :system do
  describe "List page" do
    let(:user) { FactoryBot.create(:user) }
    let!(:feature) { FactoryBot.create(:feature, user_id: user.id) }
    let!(:service_format) { FactoryBot.create(:service_format, service: feature.service) }
    let!(:service_col1) { FactoryBot.create(:service_col, service_format: service_format) }
    let!(:service_col2) { FactoryBot.create(:service_col, service_format: service_format) }
    let!(:service_col3) { FactoryBot.create(:service_col, service_format: service_format) }
    let!(:service_col4) { FactoryBot.create(:service_col, service_format: service_format) }

    before do
      driven_by(:rack_test)

      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      visit feature_path(feature)
    end

    # These 2 specs are turned off because Chromedriver ver.115 is not found yet.
    xscenario 'user creates a mapping' do
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

    xscenario 'user edits and updates a mapping' do
      click_link 'Show Mappings'

      within "#mapping_#{feature.versions.last.mappings.first.id}" do
        click_link 'Edit'
        fill_in 'mapping_user_column', with: 'new value'
        click_button 'Update'
        expect(page).to have_content 'new value'
      end
    end
  end
end
