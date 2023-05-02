require 'rails_helper'

RSpec.describe "Sites", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  def sign_in(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  describe "GET /site/index" do
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
        sign_in(user)

        get root_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /home" do
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
        sign_in(user)

        get '/home'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /dashboard" do
    # ユーザーがログインしていない場合
    context 'when a user is not logged in' do
      # GETリクエストは失敗してリダイレクトされる
      it "returns http redirect" do
        get '/dashboard'
        expect(response).to have_http_status(:redirect)
      end
    end

    # ユーザーがログイン済みで、機能を登録している場合
    context 'when a user is logged in' do
      # GETリクエストは成功する
      it "returns http success" do
        FactoryBot.create(:feature, user_id: user.id)
        sign_in(user)

        get '/dashboard'
        expect(response).to have_http_status(:success)
      end
    end

    # ユーザーがログイン済みだが、何も機能を登録していない場合
    context 'when a user is logged in and user does not have any features yet' do
      # GETリクエストは成功する
      it "returns http success" do
        sign_in(user)

        get '/dashboard'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
