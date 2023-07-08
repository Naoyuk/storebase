class VersionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_version, only: %i[update destroy]

  def index
    @versions = Version.all
  end

  def find_or_create
    version = Version.find_by(service_format_id: params[:service_format_id])
    if version.nil?
      service_format = ServiceFormat.find(params[:service_format_id])
      @feature = Feature.find_by(user_id: current_user.id, service_id: service_format.service_id)
      @version = @feature.versions.build(current: true, service_format_id: service_format.id)

      respond_to do |format|
        if @version.save_with_mappings
          format.html { redirect_to feature_mappings_path(@version.feature_id), notice: 'Version was successfully created.' }
          format.json { render json: @version, status: :created }
        else
          format.html { render 'features/show' }
          format.json { render json: @version.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to feature_mappings_path(version.feature_id) }
        format.json { render json: version, status: :created }
      end
    end
  end

  def update
    respond_to do |format|
      if @version.update(version_params)
        format.html { redirect_to feature_mappings_path(@version), notice: "Version was successfully updated." }
        format.json { render :show, status: :ok, location: @version }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @version.destroy

    respond_to do |format|
      format.html { redirect_to feature_mappings_path(@version), notice: "Version was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_version
    @version = Version.find(params[:id])
  end

  # def set_feature(feature_id)
  #   @feature = Feature.find(feature_id)
  # end

  def version_params
    params.require(:version).permit(:feature_id, :current, :service_format_id)
  end
end
