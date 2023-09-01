class PlansController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user,
only: [
  :place_and_once_again_place, :from_place_to_plan_place, :from_once_again_place_to_plan_place, :show, :edit,
  :update, :destroy,
]

  def index
    @user = User.find_by(id: session[:user_id])
    @plans = @user.plans
    @plan = Plan.new
  end

  def create
    @user = User.find_by(id: session[:user_id])
    @plan = Plan.new(params.require(:plan).permit(:plan_name, :start_time, :end_time, :user_id, :plan_color))
    if @plan.save
      @plans = @user.plans
      flash.now[:notice] = "予定を新規登録をしました"
    else
      @plans = @user.plans
      render :error
    end
  end

  def show
    @user = User.find_by(id: session[:user_id])
    @plan = Plan.find(params[:id])
    @plan_places = @plan.plan_places.includes(:category).order(:start_time)
    @plan_place = PlanPlace.new
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    if @plan.update(params.require(:plan).permit(:plan_name, :start_time, :end_time, :user_id, :plan_color))
      flash[:notice] = "登録内容を更新しました"
      redirect_to plan_path(@plan)
    else
      render "edit"
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    flash.now[:notice] = "#{@plan.plan_name}を予定から削除しました"
  end

  # 行きたい場所ともう一度行きたい場所の一覧を表示
  def place_and_once_again_place
    @user = User.find_by(id: session[:user_id])
    @plan = Plan.find(params[:id])
    @places = @user.places.includes(:category).sort_places(params[:sort_param])
    @once_again_places = @user.gone_places.where(once_again: true).includes(:category).sort_gone_places(params[:sort_param])
  end

  # 行きたい場所からplan_placeに登録するページ
  def from_place_to_plan_place
    @user = User.find_by(id: session[:user_id])
    @plan = Plan.find(params[:id])
    @place = Place.find(params[:place_id])
    @plan_place = PlanPlace.new
  end

  # もう一度行きたいに登録している場所をplan_placeに登録するページ
  def from_once_again_place_to_plan_place
    @user = User.find_by(id: session[:user_id])
    @plan = Plan.find(params[:id])
    @once_again_place = GonePlace.find(params[:gone_place_id])
    @plan_place = PlanPlace.new
  end

  def ensure_correct_user
    @plan = Plan.find(params[:id])
    if @plan.user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end
end
