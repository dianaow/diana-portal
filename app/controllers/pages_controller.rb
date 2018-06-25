class PagesController < ApplicationController
before_action :set_recommended_users

  def home
    if user_signed_in? == true
      @feed = current_user.feed.paginate(page: params[:page], per_page: 10).order("updated_at DESC")

    else                             
      @articles = Article.published
                         .where('created_at >= ?', 1.month.ago)
                         .sorted_by_popular_score
                         .take(6)
    end
  end
  
  def refresh
    @refresh = @users.where.not("users.id in (?)", @recommended.map(&:id)).order("RANDOM()").limit(5)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def follow_recommended 
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    @friend = @friendship.friend
    @replacement = @users.where.not("users.id in (?)", @recommended.map(&:id)).first
    if @friendship.save
      respond_to do |format|
        format.html { redirect_back fallback_location: users_path, :flash => { :success => "You have sent a friend request." } }
        format.js 
      end
      Notification.create!(recipient: @friendship.friend, actor: @friendship.user, action: "requested", notifiable: @friendship)
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: users_path, :flash => { :error => "Unable to request friendship." } }
        format.js
      end
    end
  end
  
  def about
  end
  
  private
  
  def set_recommended_users
    if user_signed_in? == true
      @users_list = User.sorted(current_user)
                   
      @categories = Category.top_3_visited(current_user)
      
      @array = Category.joins(:articles)
                       .where(categories: {id: @categories.ids})
                       .pluck("DISTINCT articles.user_id")
                       
      if @categories.empty? == true
        @users = @users_list
      else
        @users = User.where(id: [@array]).sorted(current_user)
      end
      
      @recommended = @users.limit(5)
        
    end
  end
  
end