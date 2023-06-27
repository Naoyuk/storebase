class SiteController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def home; end

  def profile; end

  def dashboard; end

  def unsubscribe; end
end
