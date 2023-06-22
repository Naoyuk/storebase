require 'rails_helper'

RSpec.describe "Features", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:service) { FactoryBot.create(:service) }
  let(:feature) { FactoryBot.create(:feature) }
  let(:valid_attributes) { { service_id: service.id } }
  let(:invalid_attributes) { FactoryBot.attributes_for(:feature, service_id: nil) }

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

  describe "GET /index" do
    it "returns http success" do
      get features_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_feature_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get feature_path(id: feature.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_feature_path(id: feature.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new feature record with valid parameters" do
      expect {
        post features_path, params: { feature: valid_attributes }
      }.to change(Feature, :count).by(1)

      expect(response).to redirect_to(features_url)
    end

    it "doesn't create a new feature record with invalid parameters" do
      expect {
        post features_path, params: { feature: invalid_attributes }
      }.to change(Feature, :count).by(0)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /update" do
    another_service = FactoryBot.create(:service)
    let(:new_attributes) { { service_id: another_service.id } }
    let(:invalid_new_attributes) { { service_id: nil } }

    context 'with valid attributes' do
      it "updates the requested feature data" do
        put feature_path(feature.id), params: { feature: new_attributes }
        feature.reload
        expect(feature.service_id).to eq another_service.id
      end

      it "redirects to the feature data" do
        put feature_path(feature.id), params: { feature: new_attributes }
        feature.reload
        expect(response).to redirect_to(features_url)
      end
    end

    context 'with invalid attributes' do
      it "doesn't updates the requested feature data" do
        put feature_path(feature.id), params: { feature: invalid_new_attributes }
        feature.reload
        expect(feature.service_id).not_to eq nil
      end

      it "render edit page" do
        put feature_path(feature.id), params: { feature: invalid_new_attributes }
        feature.reload
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroy the requested feature data" do
      feature_to_delete = FactoryBot.create(:feature)
      expect {
        delete feature_path(feature_to_delete.id)
      }.to change(Feature, :count).by(-1)

      expect(response).to redirect_to(features_url)
    end
  end
end
