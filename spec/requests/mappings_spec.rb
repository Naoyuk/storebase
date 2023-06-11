require 'rails_helper'

RSpec.describe "Mappings", type: :request do
  let(:feature) { FactoryBot.create(:feature) }
  let(:mapping) { FactoryBot.create(:mapping, feature: feature) }
  let(:valid_attributes) { FactoryBot.attributes_for(:mapping) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:mapping, user_id: nil) }

  describe "GET /index" do
    it "returns http success" do
      get feature_mappings_path(feature)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_feature_mapping_path(feature)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get feature_mapping_path(feature_id: feature.id, id: mapping.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_feature_mapping_path(feature_id: feature.id, id: mapping.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new mapping record with valid parameters" do
      expect {
        post feature_mappings_path(feature_id: feature.id), params: { mapping: valid_attributes }
      }.to change(Mapping, :count).by(1)

      expect(response).to redirect_to(feature_mappings_url(feature_id: feature.id))
    end
  end

  describe "PUT /update" do
    let(:new_attributes) { { user_column: 'new_column' } }

    it "updates the requested mapping data" do
      put feature_mapping_path(feature_id: feature.id, id: mapping.id), params: { mapping: new_attributes }
      mapping.reload
      expect(mapping.user_column).to eq 'new_column'
    end

    it "redirects to the mapping data" do
      put feature_mapping_path(feature_id: feature.id, id: mapping.id), params: { mapping: new_attributes }
      mapping.reload
      expect(response).to redirect_to(feature_mappings_url)
    end
  end

  describe "GET /destroy" do
    it "destroy the requested mapping data" do
      mapping_to_delete = FactoryBot.create(:mapping, feature: feature)
      expect {
        delete feature_mapping_path(feature_id: feature.id, id: mapping_to_delete.id)
      }.to change(Mapping, :count).by(-1)

      expect(response).to redirect_to(feature_mappings_url(feature_id: feature.id))
    end
  end
end
