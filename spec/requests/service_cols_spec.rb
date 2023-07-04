require 'rails_helper'

RSpec.describe "/service_cols", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let!(:service_format) { FactoryBot.create(:service_format) }
  let(:valid_attributes) { FactoryBot.attributes_for(:service_col).merge(service_format_id: service_format.id) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:service_col, ec_column: nil) }

  describe "GET /index" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        ServiceCol.create! valid_attributes
        sign_in admin
        get service_cols_url
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to the user log in page" do
        ServiceCol.create! valid_attributes
        sign_in user
        get service_cols_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to the user log in page" do
        ServiceCol.create! valid_attributes
        get service_cols_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "GET /show" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        service_col = ServiceCol.create! valid_attributes
        sign_in admin
        get service_col_url(service_col)
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        sign_in user
        get service_col_url(service_col)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        get service_col_url(service_col)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "GET /new" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        service_format = FactoryBot.create(:service_format)
        sign_in admin
        get new_service_col_url(service_format_id: service_format.id)
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to the user log in page" do
        sign_in user
        get new_service_col_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to the user log in page" do
        get new_service_col_url
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "GET /edit" do
    context 'when a admin is logged in' do
      it "renders a successful response" do
        service_col = ServiceCol.create! valid_attributes
        sign_in admin
        get edit_service_col_url(service_col)
        expect(response).to be_successful
      end
    end

    context 'when a user is logged in' do
      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        sign_in user
        get edit_service_col_url(service_col)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        get edit_service_col_url(service_col)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "POST /create" do
    let(:service_format) { FactoryBot.create(:service_format) }

    context 'when a admin is logged in' do
      before do
        sign_in admin
      end

      context "with valid parameters" do
        it "creates a new ServiceCol" do
          expect {
            post service_cols_url, params: { service_col: valid_attributes, service_format_id: service_format.id }
          }.to change(ServiceCol, :count).by(1)
        end

        it "redirects to the created service_col" do
          post service_cols_url, params: { service_col: valid_attributes, service_format_id: service_format.id }
          expect(response).to redirect_to(service_format_url(valid_attributes[:service_format_id]))
        end
      end

      context "with invalid parameters" do
        it "does not create a new ServiceCol" do
          sign_in admin
          expect {
            post service_cols_url, params: { service_col: invalid_attributes, service_format_id: service_format.id }
          }.to change(ServiceCol, :count).by(0)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          sign_in admin
          post service_cols_url, params: { service_col: invalid_attributes, service_format_id: service_format.id }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when a user is logged in' do
      it "does not create a new ServiceCol" do
        sign_in user
        expect {
          post service_cols_url, params: { service_col: valid_attributes, service_format_id: service_format.id }
        }.to change(ServiceCol, :count).by(0)
      end

      it "redirects to the user log in page" do
        sign_in user
        post service_cols_url, params: { service_col: valid_attributes, service_format_id: service_format.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "does not create a new ServiceCol" do
        expect {
          post service_cols_url, params: { service_col: valid_attributes, service_format_id: service_format.id }
        }.to change(ServiceCol, :count).by(0)
      end

      it "redirects to the user log in page" do
        post service_cols_url, params: { service_col: valid_attributes, service_format_id: service_format.id }
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
        let(:new_attributes) { FactoryBot.attributes_for(:service_col).merge(ec_column: 'new col') }

        it "updates the requested service_col" do
          service_col = ServiceCol.create! valid_attributes
          patch service_col_url(service_col), params: { service_col: new_attributes }
          service_col.reload
          expect(service_col.ec_column).to eq 'new col'
        end

        it "redirects to the service_col" do
          service_col = ServiceCol.create! valid_attributes
          patch service_col_url(service_col), params: { service_col: new_attributes }
          service_col.reload
          expect(response).to redirect_to(service_format_url(service_col.service_format_id))
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { FactoryBot.attributes_for(:service_col).merge(ec_column: nil) }

        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          service_col = ServiceCol.create! valid_attributes
          patch service_col_url(service_col), params: { service_col: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when a user is logged in' do
      let(:new_attributes) { FactoryBot.attributes_for(:service_col).merge(ec_column: 'new col') }

      before do
        sign_in user
      end

      it "does not update the requested service_col" do
        service_col = ServiceCol.create! valid_attributes
        patch service_col_url(service_col), params: { service_col: new_attributes }
        service_col.reload
        expect(service_col.ec_column).not_to eq 'new col'
      end

      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        patch service_col_url(service_col), params: { service_col: new_attributes }
        service_col.reload
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      let(:new_attributes) { FactoryBot.attributes_for(:service_col).merge(ec_column: 'new col') }

      it "does not update the requested service_col" do
        service_col = ServiceCol.create! valid_attributes
        patch service_col_url(service_col), params: { service_col: new_attributes }
        service_col.reload
        expect(service_col.ec_column).not_to eq 'new col'
      end

      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        patch service_col_url(service_col), params: { service_col: new_attributes }
        service_col.reload
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end

  describe "DELETE /destroy" do
    context 'when a admin is logged in' do
      it "destroys the requested service_col" do
        service_col = ServiceCol.create! valid_attributes
        sign_in admin
        expect {
          delete service_col_url(service_col)
        }.to change(ServiceCol, :count).by(-1)
      end

      it "redirects to the service_cols list" do
        sign_in admin
        service_col = ServiceCol.create! valid_attributes
        delete service_col_url(service_col)
        expect(response).to redirect_to(service_cols_url)
      end
    end

    context 'when a user is logged in' do
      it "does not destroy the requested service_col" do
        sign_in user
        service_col = ServiceCol.create! valid_attributes
        expect {
          delete service_col_url(service_col)
        }.to change(ServiceCol, :count).by(0)
      end

      it "redirects to the user log in page" do
        sign_in user
        service_col = ServiceCol.create! valid_attributes
        delete service_col_url(service_col)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end

    context 'when not logged in' do
      it "does not destroy the requested service_col" do
        service_col = ServiceCol.create! valid_attributes
        expect {
          delete service_col_url(service_col)
        }.to change(ServiceCol, :count).by(0)
      end

      it "redirects to the user log in page" do
        service_col = ServiceCol.create! valid_attributes
        delete service_col_url(service_col)
        expect(response).to redirect_to(new_admin_session_url)
      end
    end
  end
end
