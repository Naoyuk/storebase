require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'validates' do
    let(:service) { FactoryBot.build(:service) }
    let(:service_without_name) { FactoryBot.build(:service, name: nil) }

    it 'is valid with valid attributes' do
      expect(service).to be_valid
    end

    it 'is invalid without name' do
      expect(service_without_name).not_to be_valid
    end
  end
end
