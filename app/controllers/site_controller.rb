class SiteController < ApplicationController
  def index
  end

  def home
  end

  def dashboard
    @features = current_user.features.all
  end
end
