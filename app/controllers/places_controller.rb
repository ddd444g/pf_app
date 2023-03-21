class PlacesController < ApplicationController
  def index
  end

  def new
  end

  def create
    @place = Place.new(params.require(:place).permit(:name, :latitude, :longitude, :user_id))
    if @place.save
      flash[:notice] = "新規登録をしました"
      redirect_to :users
    else
      @user = User.find_by(params[:place][:user_id])
      @places = @user.places
      render "users/show"
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    if @place.update(params.require(:place).permit(:name, :latitude, :longitude))
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
end
