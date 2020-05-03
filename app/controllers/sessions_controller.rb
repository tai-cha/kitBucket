class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to user_path(current_user)
    end
    puts 'logged_in?'
    pp logged_in?
    puts 'current_user'
    pp current_user
  end

  def create
    user = User.find_by(screen_name: params[:session][:screen_name].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:green] = "ログインしました。"
      redirect_to mypage_path
    else
      flash.now[:red] = "idかパスワードが間違っています。ご確認の上、再度お試しください。"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:green] = "ログアウトしました。"
    redirect_to root_path
  end
end
