class MappingsController < ApplicationController
  before_action :set_feature
  before_action :set_features, only: [:show, :edit, :new]
  before_action :set_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @mappings = @feature.current_version.mappings.default_order
    @service = @feature.service
  end

  def new
    @mapping = Mapping.new(version: @feature.current_version)
  end

  def show
  end

  def edit
  end

  def update
    if @mapping.update(mapping_params)
      redirect_to feature_mappings_path(@feature)
    else
      render :edit, status: :unprocessable_entity
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
    @mapping = @feature.current_version.mappings.find(params[:id])
  end

  def mapping_params
    params.require(:mapping).permit(:user_column, :ec_column, :data_type)
  end
end
