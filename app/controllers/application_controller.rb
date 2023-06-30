class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_dashboard_items

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      features_path
    when User
      profile_path
    end
  end

  def set_dashboard_items
    if user_signed_in?
      @dashboard_items = current_user.features.order_by_platform
    else
      if defined? @dashboard_items
        remove_instance_variable :@dashboard_items
      end
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :avatar])
  end
end
