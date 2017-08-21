class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @users = User.search(params[:search])
    @followers = current_user.received_friends.all
    @following = current_user.active_friends.all
    @requested_friendships = current_user.requested_friendships
  end

  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.all
  end

end