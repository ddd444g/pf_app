class GonePlacesController < ApplicationController
  before_action :authenticate_user
  before_action :set_gone_place_ensure_correct_user, only: [:show, :edit, :update, :destroy, :once_again, :cancel_once_again]

  def index
    @gone_places = @current_user.gone_places.includes(:category).sort_gone_places(params[:sort_param]).search(params[:search])
    @once_again_places = @current_user.gone_places.where(once_again: true)
    @gone_place = GonePlace.new
    @search_keyword = params[:search]
    @gone_places_count = @gone_places.count
  end

  def create
    @gone_place = GonePlace.new(params.require(:gone_place).
    permit(:name, :user_id, :place_id, :review, :score, :latitude, :longitude,
:googlemap_name, :address, :rating, :category_id, :website))
    if @gone_place.save
      @place = Place.find_by(id: params[:gone_place][:place_id])
      @place.update(visited: true, gone_place_id: @gone_place.id)
      flash[:notice] = "#{@gone_place.name}を訪問済みに登録しました"
    else
      render :error
    end
  end

  def not_from_place_create
    @gone_place = GonePlace.new(params.require(:gone_place).
    permit(:name, :user_id, :review, :score, :latitude, :longitude, :googlemap_name,
:address, :rating, :category_id, :website))
    if @gone_place.save
      flash[:notice] = "#{@gone_place.name}を追加しました"
    else
      render :error
    end
  end

  def show
    @recommend_place = RecommendPlace.new
  end

  def edit
  end

  def update
    if @gone_place.update(params.require(:gone_place).permit(:name, :review, :score, :latitude, :longitude,
:googlemap_name, :address, :rating, :category_id, :website))
      flash[:notice] = "訪問済み場所の情報を更新しました"
      redirect_to gone_place_path(@gone_place)
    else
      render "gone_places/edit"
    end
  end

  def destroy
    if @gone_place.once_again
      @once_again_place = @gone_place
      @once_again_place.destroy
    end
    @gone_place.place.update(visited: false, gone_place_id: nil) if @gone_place.place
    @gone_place.destroy
    flash.now[:notice] = "#{@gone_place.name}を削除しました"
  end

  def once_again
    @once_again_places = @current_user.gone_places.where(once_again: true)
    if @gone_place.once_again
      flash.now[:notice] = "#{@gone_place.name}はすでに登録されています"
    else
      @gone_place.update(once_again: true)
      flash.now[:notice] = "#{@gone_place.name}をもう一度行きたいに登録しました"
    end
  end

  def cancel_once_again
    if @gone_place.once_again
      @gone_place.update(once_again: false)
      flash.now[:notice] = "#{@gone_place.name}のもう一度行きたいを解除しました"
    else
      flash.now[:notice] = "まだもう一度行きたいに登録されていません"
    end
  end

  def set_gone_place_ensure_correct_user
    @gone_place = GonePlace.find(params[:id])
    if @gone_place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end
end
