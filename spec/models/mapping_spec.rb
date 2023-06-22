require 'rails_helper'

RSpec.describe Mapping, type: :model do
  describe 'validates' do
    let(:mapping) { FactoryBot.build(:mapping) }

    it 'is valid with valid attributes' do
      expect(mapping).to be_valid
    end
  end
end
