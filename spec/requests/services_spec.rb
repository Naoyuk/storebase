require 'rails_helper'

RSpec.describe "Services", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:service) { FactoryBot.create(:service) }
  let(:platform) { FactoryBot.create(:platform) }
  let(:valid_attributes) { { name: 'something', url: 'test.com', icon: 'aaa', platform_id: platform.id } }
  let(:invalid_attributes) { FactoryBot.attributes_for(:service, name: nil) }

  describe "GET /index" do
    context 'when an admin is loggin in' do
      it "returns http success" do
        sign_in admin
        get services_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when a user is loggin in' do
      it "redirects to admin log in page" do
        sign_in user
        get services_path
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'when not logged in' do
      it "redirects to admin log in page" do
        get services_path
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  describe "GET /new" do
    context 'when an admin is loggin in' do
      it "returns http success" do
        sign_in admin
        get new_service_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when a user is loggin in' do
      it "redirects to admin log in page" do
        sign_in user
        get new_service_path
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'when not logged in' do
      it "redirects to admin log in page" do
        get new_service_path
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  describe "GET /edit" do
    context 'when an admin is loggin in' do
      it "returns http success" do
        sign_in admin
        get edit_service_path(service)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when a user is loggin in' do
      it "redirects to admin log in page" do
        sign_in user
        get edit_service_path(service)
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'when not logged in' do
      it "redirects to admin log in page" do
        get edit_service_path(service)
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  describe "POST /create" do
    context 'when an admin is loggin in' do
      context 'with valid parameters' do
        it "creates a new service record" do
          sign_in admin
          expect {
            post services_path, params: { service: valid_attributes }
          }.to change(Service, :count).by(1)

          expect(response).to redirect_to(services_url)
        end
      end

      context 'with invalid parameters' do
        it "doesn't create a new service record and render new service page" do
          sign_in admin
          expect {
            post services_path, params: { service: invalid_attributes }
          }.to change(Service, :count).by(0)

          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when a user is loggin in' do
      it "doesn't create a new service record and redirect to admin log in page" do
        sign_in user
        expect {
          post services_path, params: { service: valid_attributes }
        }.to change(Service, :count).by(0)

        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'when not logged in' do
      it "doesn't create a new service record and redirect to admin log in page" do
        expect {
          post services_path, params: { service: valid_attributes }
        }.to change(Service, :count).by(0)

        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  describe "PUT /update" do
    let(:new_attributes) { { name: 'changed' } }
    let(:invalid_new_attributes) { { name: nil } }

    context 'when an admin is loggin in' do
      before do
        sign_in admin
      end

      context 'with valid attributes' do
        it "updates the requested service data and redirect to the services page" do
          put service_path(service.id), params: { service: new_attributes }
          service.reload
          expect(service.name).to eq new_attributes[:name]
          expect(response).to redirect_to(services_url)
        end
      end

      context 'with invalid attributes' do
        it "doesn't updates the requested service data and render edit page" do
          put service_path(service.id), params: { service: invalid_new_attributes }
          service.reload
          expect(service.name).not_to eq nil
          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when a user is loggin in' do
      it "doesn't updates the requested service data and redirect to admin log in page" do
        sign_in user
        put service_path(service.id), params: { service: invalid_new_attributes }
        service.reload
        expect(service.name).not_to eq nil
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'when not logged in' do
      it "doesn't updates the requested service data and redirect to admin log in page" do
        put service_path(service.id), params: { service: invalid_new_attributes }
        service.reload
        expect(service.name).not_to eq nil
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  describe "DELETE /destroy" do
    context 'when an admin is loggin in' do
      it "destroy the requested service data and redirect to services list page" do
        service_to_delete = FactoryBot.create(:service)
        sign_in admin
        expect {
          delete service_path(service_to_delete.id)
        }.to change(Service, :count).by(-1)

        expect(response).to redirect_to(services_url)
      end
    end

    context 'when a user is loggin in' do
      it "destroy the requested service data and redirects to admin log in page" do
        sign_in user
        service_to_delete = FactoryBot.create(:service)
        expect {
          delete service_path(service_to_delete.id)
        }.to change(Service, :count).by(0)

        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'when not logged in' do
      it "doesn't destroy the requested servie data and redirects to admin log in page" do
        service_to_delete = FactoryBot.create(:service)
        expect {
          delete service_path(service_to_delete.id)
        }.to change(Service, :count).by(0)

        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end
