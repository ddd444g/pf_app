class PlanPlacesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]

  def create
    @plan_place = PlanPlace.new(params.require(:plan_place).permit(:plan_place_name, :memo, :latitude, :longitude,
:user_id, :plan_id, :start_time, :googlemap_name, :address, :rating, :category_id, :website))
    if @plan_place.save
      @plan = Plan.find_by(id: params[:plan_place][:plan_id])
      @plan_places = @plan.plan_places
      flash.now[:notice] = "#{@plan_place.plan_place_name}を追加しました"
    else
      @plan = Plan.find_by(id: params[:plan_place][:plan_id])
      render :error
    end
  end

  def from_place_to_plan_place_create
    @plan_place = PlanPlace.new(params.require(:plan_place).permit(:plan_place_name, :memo, :latitude, :longitude,
:user_id, :plan_id, :place_id, :start_time, :googlemap_name, :address, :rating, :category_id, :website))
    if @plan_place.save
      @plan = Plan.find_by(id: params[:plan_place][:plan_id])
      flash[:notice] = "#{@plan_place.plan_place_name}を追加しました"
    else
      render :error
    end
  end

  def from_once_again_place_to_plan_place_create
    @plan_place = PlanPlace.new(params.require(:plan_place).permit(:plan_place_name, :memo, :latitude, :longitude,
:user_id, :plan_id, :gone_place_id, :start_time, :googlemap_name, :address, :rating, :category_id, :website))
    if @plan_place.save
      @plan = Plan.find_by(id: params[:plan_place][:plan_id])
      flash[:notice] = "#{@plan_place.plan_place_name}を追加しました"
    else
      render :error
    end
  end

  def show
    @plan_place = PlanPlace.find(params[:id])
  end

  def edit
    @plan_place = PlanPlace.find(params[:id])
  end

  def update
    @plan_place = PlanPlace.find(params[:id])
    if @plan_place.update(params.require(:plan_place).permit(:plan_place_name, :memo, :latitude, :longitude,
:start_time, :googlemap_name, :address, :rating, :category_id, :website))
      flash[:notice] = "登録内容を更新しました"
      redirect_to plan_place_path(@plan_place)
    else
      render "edit"
    end
  end

  def destroy
    @plan_place = PlanPlace.find(params[:id])
    @plan_place.destroy
    flash.now[:notice] = "#{@plan_place.plan_place_name}を削除しました"
  end

  def ensure_correct_user
    @plan_place = PlanPlace.find(params[:id])
    if @plan_place.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end
end
