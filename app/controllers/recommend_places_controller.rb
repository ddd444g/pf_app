class RecommendPlacesController < ApplicationController
  def index
  end

  def new
  end

  def create
    @recommend_place = RecommendPlace.new(params.require(:recommend_place).permit(:recommend_place_name,
:recommend_comment, :gone_place_id, :user_id))
    if @recommend_place.save
      flash[:notice] = "おすすめ場所として公開しました"
      redirect_to user_path(@recommend_place.user)
    else
      @gone_place = GonePlace.find_by(id: params[:recommend_place][:gone_place_id])
      render "gone_places/show"
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
