require 'rails_helper'

RSpec.describe "/service_formats", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let!(:service) { FactoryBot.create(:service) }
  let(:valid_attributes) { FactoryBot.attributes_for(:service_format).merge(service_id: service.id) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:service_format, active: nil) }

  describe "GET /index" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        ServiceFormat.create!(**valid_attributes, service: service)
        sign_in admin
        get service_formats_url
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to user log in page" do
        ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        get service_formats_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to user log in page" do
        ServiceFormat.create!(**valid_attributes, service: service)
        get service_formats_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "GET /show" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in admin
        get service_format_url(service_format)
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        get service_format_url(service_format)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        get service_format_url(service_format)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "GET /new" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        sign_in admin
        get new_service_format_url
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to user log in page" do
        sign_in user
        get new_service_format_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to user log in page" do
        get new_service_format_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "GET /edit" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in admin
        get edit_service_format_url(service_format)
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        get edit_service_format_url(service_format)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        get edit_service_format_url(service_format)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "POST /create" do
    context 'when a admin is logged in' do
      before do
        sign_in admin
      end

      context "with valid parameters" do
        it "creates a new ServiceFormat" do
          expect {
            post service_formats_url, params: { service_format: valid_attributes }
          }.to change(ServiceFormat, :count).by(1)
        end

        it "redirects to the created service_format" do
          post service_formats_url, params: { service_format: valid_attributes }
          expect(response).to redirect_to(service_format_url(ServiceFormat.last))
        end
      end

      context "with invalid parameters" do
        it "does not create a new ServiceFormat" do
          expect {
            post service_formats_url, params: { service_format: invalid_attributes }
          }.to change(ServiceFormat, :count).by(0)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post service_formats_url, params: { service_format: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when a user is logged in' do
      it "does not create a new ServiceFormat" do
        sign_in user
        expect {
          post service_formats_url, params: { service_format: valid_attributes }
        }.to change(ServiceFormat, :count).by(0)
      end

      it "redirects to the user log in page" do
        sign_in user
        post service_formats_url, params: { service_format: valid_attributes }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "does not create a new ServiceFormat" do
        expect {
          post service_formats_url, params: { service_format: valid_attributes }
        }.to change(ServiceFormat, :count).by(0)
      end

      it "redirects to the user log in page" do
        post service_formats_url, params: { service_format: valid_attributes }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "PATCH /update" do
    context 'when a admin is logged in' do
      before do
        sign_in admin
      end

      context "with valid parameters" do
        let(:new_attributes) { FactoryBot.attributes_for(:service_format).merge(current: false) }

        it "updates the requested service_format" do
          service_format = ServiceFormat.create!(**valid_attributes, service: service)
          patch service_format_url(service_format), params: { service_format: new_attributes }
          service_format.reload
          expect(service_format.current).to eq false
        end

        it "redirects to the service_format" do
          service_format = ServiceFormat.create!(**valid_attributes, service: service)
          patch service_format_url(service_format), params: { service_format: new_attributes }
          service_format.reload
          expect(response).to redirect_to(service_format_url(service_format))
        end
      end

      context "with invalid parameters" do
        it "renders a response with 302 status" do
          service_format = ServiceFormat.create!(**valid_attributes, service: service)
          patch service_format_url(service_format), params: { service_format: invalid_attributes }
          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when a user is logged in' do
      let(:new_attributes) { FactoryBot.attributes_for(:service_format).merge(current: false) }

      it "does not update the ServiceFormat" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        patch service_format_url(service_format), params: { service_format: new_attributes }
        service_format.reload
        expect(service_format.current).to eq true
      end

      it "redirects to the user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        patch service_format_url(service_format), params: { service_format: new_attributes }
        service_format.reload
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      let(:new_attributes) { FactoryBot.attributes_for(:service_format).merge(current: false) }

      it "does not update the ServiceFormat" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        patch service_format_url(service_format), params: { service_format: new_attributes }
        service_format.reload
        expect(service_format.current).to eq true
      end

      it "redirects to the user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        patch service_format_url(service_format), params: { service_format: new_attributes }
        service_format.reload
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "DELETE /destroy" do
    context 'when a admin is logged in' do
      before do
        sign_in admin
      end

      it "destroys the requested service_format" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        expect {
          delete service_format_url(service_format)
        }.to change(ServiceFormat, :count).by(-1)
      end

      it "redirects to the service_formats list" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        delete service_format_url(service_format)
        expect(response).to redirect_to(service_formats_url)
      end
    end

    context 'when a user is logged in' do
      it "does not destroys the requested service_format" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        expect {
          delete service_format_url(service_format)
        }.to change(ServiceFormat, :count).by(0)
      end

      it "redirects to the user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        sign_in user
        delete service_format_url(service_format)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "does not destroys the requested service_format" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        expect {
          delete service_format_url(service_format)
        }.to change(ServiceFormat, :count).by(0)
      end

      it "redirects to the user log in page" do
        service_format = ServiceFormat.create!(**valid_attributes, service: service)
        delete service_format_url(service_format)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end
end
