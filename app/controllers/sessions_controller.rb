class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    user = User.find_by(screen_name: params[:session][:screen_name].downcase)
    if user&.authenticate(params[:session][:password])
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:red] = "idかパスワードが間違っています。ご確認の上、再度お試しください。"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
