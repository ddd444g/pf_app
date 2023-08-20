class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :show, :edit, :update]
  before_action :forbid_login_user, only: [:new, :create, :login_form, :login]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_guest_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
    @places = Place.all
    @gone_places = GonePlace.all
    @once_again_places = GonePlace.where(once_again: true)
    @recommend_places = RecommendPlace.all
    @plans = Plan.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'ユーザーを新規登録しました'
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params.require(:user).permit(:name, :email, :password, :password_confirmation))
      flash[:notice] = "ユーザーIDが「#{@user.id}」の情報を更新しました"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'ユーザーを削除しました'
    redirect_to new_user_path
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to places_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if @user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to @current_user ? user_path(@current_user) : :root
    end
  end

  def guest_login
    user = User.find_or_create_by(email: "guest@exapmle.com") do |guest_user|
      guest_user.password = SecureRandom.urlsafe_base64
      guest_user.name = "ゲストユーザー"
      guest_user.guest = true
      guest_user.save
    end
    session[:user_id] = user.id
    flash[:notice] = "ゲストユーザーとしてログインしました"
    redirect_to places_path
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest?
      flash[:notice] = "ゲストユーザーの編集はできません"
      redirect_to user_path(@user)
    end
  end
end
