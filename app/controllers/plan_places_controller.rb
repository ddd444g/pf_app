class PlanPlacesController < ApplicationController
  def create
    @user = User.find_by(id: session[:user_id])
    @plan_place = PlanPlace.new(params.require(:plan_place).permit(:plan_place_name, :memo, :latitude, :longitude,
:user_id, :plan_id, :start_time))
    if @plan_place.save
      @plan = Plan.find_by(id: params[:plan_place][:plan_id])
      flash[:notice] = "行く場所を追加しました"
      redirect_to plan_path(@plan)
    else
      @plan = Plan.find_by(id: params[:plan_place][:plan_id])
      @plan_places = @plan.plan_places
      render "plans/show"
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
:start_time))
      flash[:notice] = "登録内容を更新しました"
      redirect_to plan_path(@plan_place.plan)
    else
      render "edit"
    end
  end

  def destroy
    @plan_place = PlanPlace.find(params[:id])
    @plan_place.destroy
    flash[:notice] = "行く予定場所を削除しました"
    redirect_to plan_path(@plan_place.plan)
  end
end
