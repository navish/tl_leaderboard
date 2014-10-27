class UsersController < ApplicationController

  require 'net/http'

  def index
    sort_users
  end

  def update_users
    User.update
    sort_users
    flash[:info] = "Leaderboard Updated!"
    render :index
  end

  def delete_user
    @user = User.find(params[:user_id])
    #binding.pry
  end

  def destroy_user
    #binding.pry
  end


  def create
    #binding.pry
    @user = User.new(user_params)
    @users = User.all

    if @user.github_user?
      if @user.save
        @user.update_user_info
        AppMailer.send_secret_token(@user.id).deliver
        #binding.pry
        flash[:success] = "You've been added to the leaderboard!"
        redirect_to root_path
      else
        flash[:error] = "Must include name, GitHub username and email address."
        render :index
      end
    else
      flash[:error] = "That GitHub user doesn't exist"
      render :index
    end
  end


  private

  def sort_users
    @users = User.order(contributions: :desc)
  end

  def user_params
    params.require(:user).permit(:name, :github_username, :email)
  end

end
