class RecommendPlacesController < ApplicationController
  def index
  end

  def new
  end

  def create
    @recommend_place = RecommendPlace.new(params.require(:recommend_place).permit(:recommend_place_name,
      :recommend_comment, :gone_place_id, :user_id))
    @gone_place = GonePlace.find_by(id: params[:recommend_place][:gone_place_id])
    if @recommend_place.save
      @gone_place.update(recommend_place_id: @recommend_place.id)
      flash[:notice] = "おすすめ場所として公開しました"
      redirect_to user_path(@recommend_place.user)
    else
      render "gone_places/show"
    end
  end

  def show
    @recommend_place = RecommendPlace.find(params[:id])
    @gone_place = @recommend_place.gone_place
  end

  def edit
    @recommend_place = RecommendPlace.find(params[:id])
    @gone_place = @recommend_place.gone_place
  end

  def update
    @recommend_place = RecommendPlace.find(params[:id])
    if @recommend_place.update(params.require(:recommend_place).permit(:recommend_place_name, :recommend_comment))
      flash[:notice] = "おススメの場所の情報を更新しました"
      redirect_to user_path(@recommend_place.user)
    else
      @gone_place = @recommend_place.gone_place
      render "recommend_places/edit"
    end
  end

  def destroy
    @recommend_place = RecommendPlace.find(params[:id])
    @recommend_place.destroy
    flash[:notice] = "おススメの場所を削除しました"
    redirect_to user_path(@recommend_place.user)
  end
end
