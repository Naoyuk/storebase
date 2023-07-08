require 'rails_helper'

RSpec.describe "Mappings", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:feature) { FactoryBot.create(:feature) }
  let(:service_format) { FactoryBot.create(:service_format) }
  let(:version) { FactoryBot.create(:version, service_format: service_format, feature: feature, current: true) }
  let(:mapping) { FactoryBot.create(:mapping, version: version) }
  let(:valid_attributes) { FactoryBot.attributes_for(:mapping) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:mapping, user_id: nil) }

  before do
    sign_in user
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

  describe "DELETE /destroy" do
    it "destroy the requested mapping data" do
      service_format = FactoryBot.create(:service_format)
      version = FactoryBot.create(:version, service_format: service_format, feature: feature, current: true)
      mapping_to_delete = FactoryBot.create(:mapping, version: version)
      expect {
        delete feature_mapping_path(feature_id: feature.id, id: mapping_to_delete.id)
      }.to change(Mapping, :count).by(-1)

      expect(response).to redirect_to(feature_mappings_url(feature_id: feature.id))
    end
  end
end
