require 'rails_helper'

RSpec.describe "Features", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario 'user has own features' do
    user = FactoryBot.create(:user)
    another_user = FactoryBot.create(:user)
    feature1 = FactoryBot.create(:feature, user_id: user.id)
    feature2 = FactoryBot.create(:feature, user_id: user.id)
    feature3 = FactoryBot.create(:feature, user_id: another_user.id)
    feature4 = FactoryBot.create(:feature, user_id: another_user.id)

    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit '/dashboard'
    expect(page).to have_content feature1.name
    expect(page).to have_content feature2.name
    expect(page).not_to have_content feature3.name
    expect(page).not_to have_content feature4.name
  end
end
