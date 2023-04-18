class GonePlacesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @gone_place = GonePlace.new
    @user = User.find_by(id: session[:user_id])
  end

  def create
    @gone_place = GonePlace.new(params.require(:gone_place).
    permit(:name, :user_id, :place_id, :review, :score, :latitude, :longitude))
    if @gone_place.save
      @place = Place.find_by(id: params[:gone_place][:place_id])
      @place.destroy
      flash[:notice] = "訪問済みに登録し、行きたい場所から削除しました"
      redirect_to user_path(@gone_place.user)
    else
      @place = Place.find_by(id: params[:gone_place][:place_id])
      render "places/show"
    end
  end

  def not_from_place_create
    @user = User.find_by(id: session[:user_id])
    @gone_place = GonePlace.new(params.require(:gone_place).
    permit(:name, :user_id, :review, :score, :latitude, :longitude))
    if @gone_place.save
      flash[:notice] = "訪問済みに登録しました"
      redirect_to user_path(@user)
    else
      render "gone_places/new"
    end
  end

  def show
    @gone_place = GonePlace.find(params[:id])
    @recommend_place = RecommendPlace.new
  end

  def edit
    @gone_place = GonePlace.find(params[:id])
  end

  def update
    @gone_place = GonePlace.find(params[:id])
    if @gone_place.update(params.require(:gone_place).permit(:name, :review, :score, :latitude, :longitude))
      flash[:notice] = "訪問済み場所の情報を更新しました"
      redirect_to user_path(@gone_place.user)
    else
      render "gone_places/edit"
    end
  end

  def destroy
    @gone_place = GonePlace.find(params[:id])
    @gone_place.destroy
    flash[:notice] = "訪問済み場所を削除しました"
    redirect_to user_path(@gone_place.user)
  end

  def once_again
    @gone_place = GonePlace.find(params[:id])
    if @gone_place.once_again
      flash[:notice] = "すでに登録されています"
    else
      @gone_place.update(once_again: true)
      flash[:notice] = "もう一度行きたいに登録しました"
    end
    redirect_to user_path(@current_user)
  end

  def cancel_once_again
    @gone_place = GonePlace.find(params[:id])
    if @gone_place.once_again
      @gone_place.update(once_again: false)
      flash[:notice] = "もう一度行きたいを解除しました"
    else
      flash[:notice] = "まだもう一度行きたいに登録されていません"
    end
    redirect_to user_path(@current_user)
  end

  def ensure_correct_user
    @gone_place = GonePlace.find(params[:id])
    if @gone_place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end
end
