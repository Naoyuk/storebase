# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_user, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def reject_user
    user = User.find_by(email: params[:user][:email].downcase)
    if user
      if (user.valid_password?(params[:user][:password]) && (user.expired_account?))
        sign_out user
        flash[:alert] = "Account Canceled. Resubscribe to regain access and restore your previous settings."
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = "Invalid Email or password"
      redirect_to new_user_session_path
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
