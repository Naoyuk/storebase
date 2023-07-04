class ServiceColsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_service_col, only: %i[show edit update destroy]

  # GET /service_cols or /service_cols.json
  def index
    @service_cols = ServiceCol.all
  end

  # GET /service_cols/1 or /service_cols/1.json
  def show
  end

  # GET /service_cols/new
  def new
    @service_col = ServiceFormat.find(params[:service_format_id]).service_cols.build
  end

  # GET /service_cols/1/edit
  def edit
  end

  # POST /service_cols or /service_cols.json
  def create
    @service_col = ServiceFormat.find(params[:service_format_id]).service_cols.build(service_col_params)

    respond_to do |format|
      if @service_col.save
        format.html { redirect_to service_format_url(@service_col.service_format), notice: "Service col was successfully created." }
        format.json { render :show, status: :created, location: @service_col }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service_col.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_cols/1 or /service_cols/1.json
  def update
    respond_to do |format|
      if @service_col.update(service_col_params)
        format.html { redirect_to service_format_url(@service_col.service_format), notice: "Service col was successfully updated." }
        format.json { render :show, status: :ok, location: @service_col }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service_col.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_cols/1 or /service_cols/1.json
  def destroy
    @service_col.destroy

    respond_to do |format|
      format.html { redirect_to service_cols_url, notice: "Service col was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_service_col
    @service_col = ServiceCol.find(params[:id])
  end

  def service_col_params
    params.require(:service_col).permit(:service_format_id, :ec_column, :data_type)
  end
end
