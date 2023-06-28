require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /unsubscribe" do
    # ユーザーがログインしていない場合
    context 'when a user is not logged in' do
      # GETリクエストは失敗してリダイレクトされる
      it "returns http redirect" do
        get root_path
        expect(response).to have_http_status(:redirect)
      end
    end

    # ユーザーがログイン済みの場合
    context 'when a user is logged in' do
      # GETリクエストは成功する
      it "returns http success" do
        sign_in user

        get root_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      sign_in user
    end

    it 'user is soft deleted' do
      delete user_registration_path
      expect(response).to have_http_status(302)
    end
  end
end
