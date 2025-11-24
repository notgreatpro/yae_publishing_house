class Admin::SessionsController < ApplicationController
  def new
    # renders login form
  end

  def create
    admin = Admin.find_by(username: params[:username])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path, notice: "Logged out!"
  end
end