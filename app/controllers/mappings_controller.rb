class MappingsController < ApplicationController
  before_action :set_feature
  before_action :set_features, only: [:index, :show, :edit, :new]
  before_action :set_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @mappings = @feature.mappings
  end

  def new
    @mapping = Mapping.new
  end

  def show
  end

  def edit
  end

  def create
    @mapping = @feature.mappings.new(mapping_params)
    if @mapping.save
      redirect_to feature_path(@feature)
    else
      render :new
    end
  end

  def update
    if @mapping.update(mapping_params)
      redirect_to feature_mappings_path(@feature)
    else
      render :edit
    end
  end

  def destroy
    @mapping.destroy
    redirect_to feature_mappings_path(@feature)
  end

  private

  def set_feature
    @feature = Feature.find(params[:feature_id])
  end

  def set_features
    @features = current_user.features.order_by_platform
  end

  def set_mapping
    @mapping = @feature.mappings.find(params[:id])
  end

  def mapping_params
    params.require(:mapping).permit(:user_column, :ec_column, :data_type)
  end
end
