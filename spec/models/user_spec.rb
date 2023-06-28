require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates' do
    let(:user) { FactoryBot.build(:user, email: 'aaa@example.com') }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end
  end

  describe '#soft_delete' do
    let(:user) { FactoryBot.build(:user) }

    it 'set current date to delted_at' do
      expect(user.deleted_at).to eq nil
      user.soft_delete
      expect(user.deleted_at).not_to be_nil
    end
  end

  describe '#requested_cancel?' do
    context 'when user requested cancel' do
      let(:user) { FactoryBot.build(:user) }

      before do
        user.soft_delete
      end

      it 'returns true' do
        expect(user.requested_cancel?).to eq true
      end
    end

    context "when user doesn't request cancel yet" do
      let(:user) { FactoryBot.build(:user) }

      it 'returns false' do
        expect(user.requested_cancel?).to eq false
      end
    end
  end

  describe '#expired_account?' do
    let(:user) { FactoryBot.create(:user) }

    context 'when the day is 30th day from cancel request' do
      it 'returns false' do
        user.update(deleted_at: Time.current.ago(30.days))
        expect(user.expired_account?).to eq false
      end
    end

    context 'when the day is 31th day from cancel request' do
      it 'returns true' do
        user.update(deleted_at: Time.current.ago(31.days))
        expect(user.expired_account?).to eq true
      end
    end
  end
end
