class ServicesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_service, only: [:edit, :update, :destroy]

  def index
    @services = Service.order_by_platform
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to services_path
    else
      render :new
    end
  end

  def update
    if @service.update(service_params)
      redirect_to services_path
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path
  end

  def converter
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :platform_id, :url, :icon)
  end
end
