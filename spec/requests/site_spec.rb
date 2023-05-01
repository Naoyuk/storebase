require 'rails_helper'

RSpec.describe "Sites", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:feature) { FactoryBot.create(:feature, user_id: user.id) }

  def sign_in(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  before do
    sign_in(user)
  end

  describe "GET /site/index" do
    it "returns http success" do

      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /home" do
    it "returns http success" do
      get '/home'
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /dashboard" do
    it "returns http success" do
      get '/dashboard'
      expect(response).to have_http_status(:success)
    end
  end
end
