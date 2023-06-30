require 'rails_helper'

RSpec.describe "Features", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:service) { FactoryBot.create(:service) }
  let(:feature) { FactoryBot.create(:feature) }
  let(:user_feature) { FactoryBot.create(:feature, user: user) }
  let(:valid_attributes) { { service_id: service.id } }
  let(:invalid_attributes) { FactoryBot.attributes_for(:feature, service_id: nil) }
  let(:csv_file) { fixture_file_upload('input.csv', 'text/csv') }

  describe "GET /index" do
    context 'when a user is loggin in' do
      it "returns http success" do
        sign_in user
        get features_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an admin is loggin in' do
      it "redirects" do
        sign_in admin
        get features_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /new" do
    context 'when a user is loggin in' do
      it "returns http success" do
        sign_in user
        get new_feature_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an admin is loggin in' do
      it "redirects" do
        sign_in admin
        get new_feature_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /show" do
    context 'when a user is loggin in' do
      it "returns http success" do
        sign_in user
        get feature_path(id: feature.id)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an admin is loggin in' do
      it "returns http success" do
        sign_in admin
        get feature_path(id: feature.id)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /edit" do
    context 'when a user is loggin in' do
      it "returns http success" do
        sign_in user
        get edit_feature_path(id: feature.id)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an admin is loggin in' do
      it "redirects" do
        sign_in admin
        get edit_feature_path(id: feature.id)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "POST /create" do
    context 'when a user is loggin in' do
      it "creates a new feature record with valid parameters" do
        sign_in user
        expect {
          post features_path, params: { feature: valid_attributes }
        }.to change(Feature, :count).by(1)

        expect(response).to redirect_to(features_url)
      end

      it "doesn't create a new feature record with invalid parameters" do
        expect {
          post features_path, params: { feature: invalid_attributes }
        }.to change(Feature, :count).by(0)

        expect(response).to have_http_status(302)
      end
    end

    context 'when an admin is loggin in' do
      it "doesn't create a new feature record" do
        sign_in admin
        expect {
          post features_path, params: { feature: valid_attributes }
        }.to change(Feature, :count).by(0)

        expect(response).to have_http_status(302)
      end
    end
  end

  describe "PUT /update" do
    another_service = FactoryBot.create(:service)
    let(:new_attributes) { { service_id: another_service.id } }
    let(:invalid_new_attributes) { { service_id: nil } }

    context 'when a user is loggin in' do
      before do
        sign_in user
      end

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

    context 'when an admin is loggin in' do
      it "doesn't updates the requested feature data" do
        sign_in admin
        put feature_path(feature.id), params: { feature: invalid_new_attributes }
        feature.reload
        expect(feature.service_id).not_to eq nil
      end
    end
  end

  describe "DELETE /destroy" do
    context 'when a user is loggin in' do
      it "destroy the requested feature data" do
        sign_in user
        feature_to_delete = FactoryBot.create(:feature)
        expect {
          delete feature_path(feature_to_delete.id)
        }.to change(Feature, :count).by(-1)

        expect(response).to redirect_to(features_url)
      end
    end

    context 'when an admin is loggin in' do
      it "destroy the requested feature data" do
        sign_in admin
        feature_to_delete = FactoryBot.create(:feature)
        expect {
          delete feature_path(feature_to_delete.id)
        }.to change(Feature, :count).by(0)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /convert" do
    context 'when the uploaded file and selection of feature are correct' do
      it "converts the uploaded csv file and returns the converted file" do
        sign_in user
        post convert_feature_path(user_feature.id), params: { csv_file: csv_file, feature_id: user_feature.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the uploaded file is missing' do
      it "redirect to converter page" do
        sign_in user
        post convert_feature_path(user_feature.id), params: { csv_file: nil, feature_id: user_feature.id }
        expect(response).to have_http_status(302)
      end
    end
  end
end
