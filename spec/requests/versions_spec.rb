require 'rails_helper'

RSpec.describe "/versions", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:feature) { FactoryBot.create(:feature, user: user) }
  let!(:service_format) { FactoryBot.create(:service_format, service: feature.service) }

  describe "POST /find_or_create" do
    before do
      FactoryBot.create(:service_col, service_format: service_format)
      FactoryBot.create(:service_col, service_format: service_format)
      FactoryBot.create(:service_col, service_format: service_format)
      sign_in user
    end

    context 'when a version is not existed yet' do
      it 'creates a version' do
        expect {
          post find_or_create_version_path(service_id: service_format.service_id, service_format_id: service_format.id)
        }.to change(Version, :count).by(1)
      end

      it 'creates mappings duplicated from ServiceCol and related to the version' do
        expect {
          post find_or_create_version_path(service_id: service_format.service_id, service_format_id: service_format.id)
        }.to change(Mapping, :count).by(3)
      end

      it 'returns https redirect' do
        post find_or_create_version_path(service_id: service_format.service_id, service_format_id: service_format.id)
        expect(response).to have_http_status(302)
      end

      it 'redirects to mappings list page' do
        post find_or_create_version_path(service_id: service_format.service_id, service_format_id: service_format.id)
        expect(response).to redirect_to feature_mappings_path(feature)
      end
    end

    context 'when a version is existed' do
      before do
        service = FactoryBot.create(:service)
        @service_format = FactoryBot.create(:service_format, service: service)
        feature = FactoryBot.create(:feature, service: service, user: user)
        version = FactoryBot.create(:version, feature: feature, service_format: @service_format)
        FactoryBot.create(:mapping, version: version)
      end

      it "doesn't create a version" do
        expect {
          post find_or_create_version_path(service_format_id: @service_format.id)
        }.to change(Version, :count).by(0)
      end

      it "doesn't create mappings" do
        expect {
          post find_or_create_version_path(service_format_id: @service_format.id)
        }.to change(Mapping, :count).by(0)
      end

      it 'returns https success(renders a mapping list page)' do
        post find_or_create_version_path(service_format_id: @service_format.id)
        expect(response).to have_http_status(302)
      end
    end
  end
end
