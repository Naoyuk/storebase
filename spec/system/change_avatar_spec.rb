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

  scenario 'user has an avatar image' do
    visit '/profile'
    expect(page).to have_css("img[src*='user1.png']")
  end

  scenario 'user can change an avatar image' do
    visit edit_user_registration_path

    attach_file('user_avatar', Rails.root.join('spec/fixtures/user2.png'))
    click_button 'Update'

    expect(page).to have_css("img[src*='user2.png']")
  end
end
