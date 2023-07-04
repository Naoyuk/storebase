require 'rails_helper'

RSpec.describe "Services", type: :system do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    driven_by(:rack_test)

    visit new_admin_session_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log in'
  end

  scenario 'features are sorted by platforms' do
    platform1 = FactoryBot.create(:platform)
    platform2 = FactoryBot.create(:platform)
    service1_p2 = FactoryBot.create(:service, platform: platform2)
    service2_p1 = FactoryBot.create(:service, platform: platform1)
    service3_p1 = FactoryBot.create(:service, platform: platform1)
    service4_p2 = FactoryBot.create(:service, platform: platform2)

    service1_row = "#{service1_p2.platform.name}\n#{service1_p2.icon} #{service1_p2.name}\n#{service1_p2.url}"
    service2_row = "#{service2_p1.platform.name}\n#{service2_p1.icon} #{service2_p1.name}\n#{service2_p1.url}"
    service3_row = "#{service3_p1.platform.name}\n#{service3_p1.icon} #{service3_p1.name}\n#{service3_p1.url}"
    service4_row = "#{service4_p2.platform.name}\n#{service4_p2.icon} #{service4_p2.name}\n#{service4_p2.url}"

    visit services_path
    expect(page.text).to match %r{#{service2_row}[\s\S]*#{service3_row}[\s\S]*#{service1_row}[\s\S]*#{service4_row}}
    expect(page.text).not_to match %r{#{service3_row}[\s\S]*#{service2_row}[\s\S]*#{service1_row}[\s\S]*#{service4_row}}
    expect(page.text).not_to match %r{#{service1_row}[\s\S]*#{service2_row}[\s\S]*#{service3_row}[\s\S]*#{service4_row}}
  end
end
