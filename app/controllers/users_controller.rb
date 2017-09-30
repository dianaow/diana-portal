class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    @users = User.search(params[:search])
  end
  
  def followers
    @followers = current_user.received_friends.all
    @requested_friendships = current_user.requested_friendships.all

  end
  
  def following
    @following = current_user.active_friends.all
  end
  
  def search
    param = params[:q][:term] rescue ""
    results = User.all_except(current_user).where("users.email iLike ? ", "%#{param}%")
    render json: {:users => results }
  end

  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.all
  end

end