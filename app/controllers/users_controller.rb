class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = User.ransack(params[:user])
    @users = @search.result(distinct: true).paginate(page: params[:page], per_page: 10)
  end
  
  def followers
    @followers = current_user.received_friends.all
    @requested_friendships = current_user.requested_friendships.all
  end
  
  def following
    @following = current_user.active_friends.all
  end

  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.all
  end
  
  def search
    param = params[:q][:term] rescue ""
    results = User.all_except(current_user).where("users.email iLike ? ", "%#{param}%")
    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { render json:{:users => results } }
    end
  end


end