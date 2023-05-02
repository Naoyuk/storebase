require 'rails_helper'

RSpec.describe Platform, type: :model do
  describe 'validates' do
    let(:platform) { FactoryBot.build(:platform) }
    let(:platform_without_name) { FactoryBot.build(:platform, name: nil) }

    it 'is valid with valid attributes' do
      expect(platform).to be_valid
    end

    it 'is invalid without name' do
      expect(platform_without_name).not_to be_valid
    end
  end
end
