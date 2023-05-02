require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'validates' do
    let(:service) { FactoryBot.build(:service) }

    it 'is valid with valid attributes' do
      expect(service).to be_valid
    end
  end
end
