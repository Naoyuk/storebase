class SiteController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def home; end

  def dashboard
    @features = current_user.features.all
  end
end
