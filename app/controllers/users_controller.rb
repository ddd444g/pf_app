class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :show, :edit, :update]
  before_action :forbid_login_user, only: [:new, :create, :login_form, :login]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
    @places = Place.all
    @gone_places = GonePlace.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'ユーザーを新規登録しました'
      redirect_to("/users/#{@user.id}")
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @place = Place.new
    @places = @user.places
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params.require(:user).permit(:name, :email, :password, :password_confirmation))
      flash[:notice] = "ユーザーIDが「#{@user.id}」の情報を更新しました"
      redirect_to("/users/#{@user.id}")
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'ユーザーを削除しました'
    redirect_to :users
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users")
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
    redirect_to("/login")
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if @user != @current_user
      flash[:notice] = "権限がありません"
      redirect_to("/users")
    end
  end
end
