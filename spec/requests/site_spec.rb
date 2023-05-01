require 'rails_helper'

RSpec.describe "Sites", type: :request do
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
