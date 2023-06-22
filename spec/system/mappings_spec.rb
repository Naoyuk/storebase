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

    visit feature_path(feature)

    expect{
      fill_in 'mapping_user_column', with: 'new user column'
      fill_in 'mapping_ec_column', with: 'new ec column'
      select 'String', from: 'mapping_data_type'
      click_button 'Add'
    }.to change(Mapping, :count).by(1)
    
    expect(page).to have_content 'new user column'
    expect(page).to have_content 'new ec column'
    expect(page).to have_content 'String'
  end
end
