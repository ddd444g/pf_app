class PlacesController < ApplicationController
  before_action :authenticate_user
  before_action :set_place_ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :search_keyword_params, only: [:index]

  def index
    @places = @current_user.places.includes(:category).sort_places(params[:sort_param]).search(params[:search])
    @place = Place.new
  end

  def create
    @place = Place.new(place_params_use_in_create)
    if @place.save
      flash[:notice] = "#{@place.name}を追加しました"
    else
      render :error
    end
  end

  def show
    @gone_place = GonePlace.new
  end

  def edit
  end

  def update
    if @place.update(place_params_update)
      flash[:notice] = "登録内容を更新しました"
      redirect_to place_path(@place)
    else
      render "edit"
    end
  end

  def destroy
    @place.destroy
    flash.now[:notice] = "#{@place.name}を削除しました"
  end

  def new_from_recommend_places
    @place = Place.new(place_params_use_in_new_from_recommend_places)
    if @place.save
      flash[:notice] = "#{@place.name}を追加しました"
    else
      render :error
    end
  end

  def set_place_ensure_correct_user
    @place = Place.find(params[:id])
    if @place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end

  private

  def place_params_use_in_create
    params.require(:place).permit(:name, :memo, :latitude, :longitude, :user_id, :googlemap_name,
      :address, :rating, :category_id, :website)
  end

  def place_params_use_in_new_from_recommend_places
    params.require(:place).
      permit(:name, :memo, :latitude, :longitude, :user_id, :recommend_place_id, :googlemap_name, :address,
:rating, :category_id, :website)
  end

  def place_params_update
    params.require(:place).permit(:name, :memo, :latitude, :longitude, :googlemap_name, :address,
      :rating, :category_id, :website)
  end
end
