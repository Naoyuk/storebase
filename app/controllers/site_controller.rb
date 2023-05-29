class SiteController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def home; end

  def dashboard
    @features = current_user.features.all
    platforms = []
    @features.each do |f|
      platforms << f.service.platform
    end
    @platforms = platforms.uniq
  end
end
