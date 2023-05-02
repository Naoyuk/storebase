require 'rails_helper'

RSpec.describe Platform, type: :model do
  describe 'validates' do
    let(:platform) { FactoryBot.build(:platform) }

    it 'is valid with valid attributes' do
      expect(platform).to be_valid
    end
  end
end
