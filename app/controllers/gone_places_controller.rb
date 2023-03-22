class GonePlacesController < ApplicationController
  def index
  end

  def new
  end

  def create
    @gone_place = GonePlace.new(params.require(:gone_place).
    permit(:name, :user_id, :place_id, :review, :score, :latitude, :longitude))
    if @gone_place.save
      @place = Place.find(params[:gone_place][:place_id])
      @place.destroy
      flash[:notice] = "訪問済みに登録し、行きたい場所から削除しました"
      redirect_to :users
    else
      @place = Place.find_by(params[:gone_place][:place_id])
      render "places/show"
    end
  end

  def show
    @gone_place = GonePlace.find(params[:id])
  end

  def edit
    @gone_place = GonePlace.find(params[:id])
  end

  def update
    @gone_place = GonePlace.find(params[:id])
    if @gone_place.update(params.require(:gone_place).permit(:name, :review, :score, :latitude, :longitude))
      flash[:notice] = "訪問済み場所の情報を更新しました"
      redirect_to :users
    else
      render "gone_places/edit"
    end
  end

  def destroy
    @gone_place = GonePlace.find(params[:id])
    @gone_place.destroy
    flash[:notice] = "訪問済み場所を削除しました"
    redirect_to :users
  end
end
