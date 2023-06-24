class FeaturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feature, only: [:show, :edit, :update, :destroy]
  before_action :set_features_and_platforms, only: [:index, :show, :edit, :new]

  def index
  end

  def new
    @feature = Feature.new
  end

  def edit
  end

  def show
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

  def converter
  end

  def convert
    if params[:feature_id].nil?
      flash[:alert] = 'Please choose a target service.'
      return redirect_to converter_path
    else
      @feature = Feature.find(params[:feature_id])
    end

    if params[:csv_file]
      input_file_path = params[:csv_file].path
      # @feature.convert_csv(input_file_path)は成功したかどうかのboolとcsvファイルまたはエラーの配列を返す
      # 多重代入によりsuccessにtrueやfalse、resultに"path/to/converted/file.csv"や"Error message describing what went wrong"といった値が入る
      success, result = @feature.convert_csv(input_file_path)
      if success
        send_file result, type: 'text/csv', filename: 'output.csv', disposition: 'attachment'
      else
        flash[:alert] = result.join(', ')
        return redirect_to converter_path
      end
    else
      flash[:alert] = 'Please upload a csv file.'
      redirect_to converter_path
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def set_features_and_platforms
    @features = current_user.features.order_by_platform
    platforms = []
    @features.each do |f|
      platforms << f.service.platform
    end
    @platforms = platforms.uniq
  end

  def feature_params
    params.require(:feature).permit(:service_id)
  end
end
