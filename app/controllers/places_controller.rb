class PlacesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @place = Place.new
    @user = User.find_by(id: session[:user_id])
  end

  def create
    @place = Place.new(params.require(:place).permit(:name, :memo, :latitude, :longitude, :user_id))
    if @place.save
      flash[:notice] = "新規登録をしました"
      redirect_to :users
    else
      @user = User.find_by(id: session[:user_id])
      render "places/new"
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
      redirect_to :users
    else
      render "edit"
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to :users
  end

  def ensure_correct_user
    @place = Place.find(params[:id])
    if @place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to("/users")
    end
  end
end
