class UsersController < ApplicationController
  def new
    @user ||= User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:green] = 'アカウントが作成されました！'
      redirect_to root_path
    else
      redirect_to sign_up_path
    end
  end

  def show
    @user = User.find_by(screen_name: params[:screen_name])
  end

  def destroy
    @user = User.find_by(screen_name: params[:screen_name])
  end


  private

  def user_params
    params.require(:user).permit(:name, :screen_name, :password, :profile )
  end
end
