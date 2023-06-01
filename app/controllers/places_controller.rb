class PlacesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @user = User.find_by(id: session[:user_id])
    @places = @user.places
    @place = Place.new
  end

  def create
    @user = User.find_by(id: session[:user_id])
    @place = Place.new(params.require(:place).permit(:name, :memo, :latitude, :longitude, :user_id, :googlemap_name,
:address, :rating))
    if @place.save
      @places = @user.places
      flash.now[:notice] = "行きたい場所を追加しました"
    else
      @places = @user.places
      render :error
    end
  end

  def show
    @place = Place.find(params[:id])
    @gone_place = GonePlace.new
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    if @place.update(params.require(:place).permit(:name, :memo, :latitude, :longitude))
      flash[:notice] = "登録内容を更新しました"
      redirect_to user_path(@place.user)
    else
      render "edit"
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash.now[:notice] = "#{@place.name}を削除しました"
  end

  def new_from_recommend_places
    @place = Place.new(params.require(:place).
    permit(:name, :memo, :latitude, :longitude, :user_id, :recommend_place_id))
    if @place.save
      flash[:notice] = "おすすめ場所から行きたい場所に登録をしました"
      redirect_to user_path(@place.user)
    else
      @user = User.find_by(id: session[:user_id])
      @recommend_place = RecommendPlace.find_by(id: params[:gone_place][:recommend_place_id])
      render "recommend_places/show"
    end
  end

  def ensure_correct_user
    @place = Place.find(params[:id])
    if @place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end
end
