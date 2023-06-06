require 'rails_helper'

RSpec.describe Feature, type: :model do
  describe 'validates' do
    let(:feature) { FactoryBot.build(:feature) }

    it 'is valid with valid attributes' do
      expect(feature).to be_valid
    end
  end
end
