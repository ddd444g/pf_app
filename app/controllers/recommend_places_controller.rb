class RecommendPlacesController < ApplicationController
  before_action :authenticate_user
  before_action :set_recommend_place_ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @recommend_places = RecommendPlace.includes(:user,
:category).all.sort_recommend_places(params[:sort_param]).search(params[:search])
    @search_keyword = params[:search]
    @recommend_places_count = @recommend_places.count
  end

  def create
    @recommend_place = RecommendPlace.new(recommend_place_params)
    @gone_place = GonePlace.find_by(id: params[:recommend_place][:gone_place_id])
    if @recommend_place.save
      @gone_place.update(recommend_place_id: @recommend_place.id, recommend: true)
      flash[:notice] = "おすすめ場所として公開しました"
    else
      render :error
    end
  end

  def show
    @recommend_place = RecommendPlace.find(params[:id])
    @gone_place = @recommend_place.gone_place
    @place = Place.new
  end

  def edit
    @gone_place = @recommend_place.gone_place
  end

  def update
    if @recommend_place.update(recommend_place_params_update)
      flash[:notice] = "おすすめの場所の情報を更新しました"
      redirect_to recommend_place_path(@recommend_place)
    else
      @gone_place = @recommend_place.gone_place
      render "recommend_places/edit"
    end
  end

  def destroy
    @recommend_place.destroy
    @gone_place = @recommend_place.gone_place
    @gone_place.update(recommend: false, recommend_place_id: nil)
    flash.now[:notice] = "#{@recommend_place.recommend_place_name}をおすすめから削除しました"
  end

  def my_post_index
    @recommend_places = RecommendPlace.includes(:user,
:category).where(user_id: @current_user.id).sort_recommend_places(params[:sort_param]).search(params[:search])
    @search_keyword = params[:search]
    @recommend_places_count = @recommend_places.count
  end

  def set_recommend_place_ensure_correct_user
    @recommend_place = RecommendPlace.find(params[:id])
    if @recommend_place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end

  private

  def recommend_place_params
    params.require(:recommend_place).permit(:recommend_place_name,
      :recommend_comment, :gone_place_id, :user_id, :googlemap_name, :address, :rating, :category_id, :website)
  end

  def recommend_place_params_update
    params.require(:recommend_place).permit(:recommend_place_name, :recommend_comment,
      :category_id)
  end
end
