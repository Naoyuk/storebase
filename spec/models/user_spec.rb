require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates' do
    let(:user) { FactoryBot.build(:user) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end
  end
end
