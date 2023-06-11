class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :destroy]

  def index
    @features = Feature.where(user_id: current_user.id)
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = Feature.new(feature_params)
    @feature.user_id = current_user.id
    if @feature.save
      redirect_to features_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @feature.update(feature_params)
      redirect_to features_path
    else
      render :edit
    end
  end

  def destroy
    @feature.destroy
    redirect_to features_path
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:service_id)
  end
end
