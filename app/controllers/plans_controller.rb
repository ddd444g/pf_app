class PlansController < ApplicationController
  before_action :authenticate_user

  def index
    @user = User.find_by(id: session[:user_id])
    @plans = @user.plans
  end

  def new
    @plan = Plan.new
    @user = User.find_by(id: session[:user_id])
  end

  def create
    @plan = Plan.new(params.require(:plan).permit(:plan_name, :start_time, :end_time, :user_id))
    if @plan.save
      flash[:notice] = "新規登録をしました"
      redirect_to plan_path(@plan)
    else
      @user = User.find_by(id: session[:user_id])
      render "plans/new"
    end
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    if @plan.update(params.require(:plan).permit(:plan_name, :start_time, :end_time, :user_id))
      flash[:notice] = "登録内容を更新しました"
      redirect_to plan_path(@plan)
    else
      render "edit"
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    flash[:notice] = "予定を削除しました"
    redirect_to plans_path
  end
end
