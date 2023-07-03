class ServiceFormatsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_service_format, only: %i[ show edit update destroy ]

  # GET /service_formats or /service_formats.json
  def index
    @service_formats = ServiceFormat.all
  end

  # GET /service_formats/1 or /service_formats/1.json
  def show
  end

  # GET /service_formats/new
  def new
    @service_format = ServiceFormat.new
  end

  # GET /service_formats/1/edit
  def edit
  end

  # POST /service_formats or /service_formats.json
  def create
    @service_format = ServiceFormat.new(service_format_params)

    respond_to do |format|
      if @service_format.save
        format.html { redirect_to service_format_url(@service_format), notice: "Service format was successfully created." }
        format.json { render :show, status: :created, location: @service_format }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service_format.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_formats/1 or /service_formats/1.json
  def update
    respond_to do |format|
      if @service_format.update(service_format_params)
        format.html { redirect_to service_format_url(@service_format), notice: "Service format was successfully updated." }
        format.json { render :show, status: :ok, location: @service_format }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service_format.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_formats/1 or /service_formats/1.json
  def destroy
    @service_format.destroy

    respond_to do |format|
      format.html { redirect_to service_formats_url, notice: "Service format was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_format
      @service_format = ServiceFormat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_format_params
      params.require(:service_format).permit(:service_id, :version, :active, :current)
    end
end
