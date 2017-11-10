class PagesController < ApplicationController
before_action :authenticate_user!

  def home
      @feed = current_user.feed.paginate(page: params[:page], per_page: 20).order("updated_at DESC")
      respond_to do |format|
        format.html
        format.js
      end
      
      @featured_article = Article.published.where('created_at >= ?', 1.week.ago).sorted_by_popular_score.first
      
      @categories = Category.where.not(impressions_count: 0).order("impressions_count DESC").limit(3)
      @array = Category.joins(:articles)
                       .where(categories: {id: @categories.ids})
                       .pluck("DISTINCT articles.user_id")
                   
      @users = User.where(id: [@array])
                   .where.not(id: current_user.self_initiated_friends)
                   .where.not(id: current_user)
                   .top_users

      @recommended = @users.limit(5)
      
      @refresh = @users.order('random()').limit(5)
      
      if params[:id]
        @replacement = @users.where('id NOT IN (?)', @recommended).where.not(id: params[:id]).first
      else
        @recommended
      end
      respond_to do |format|
        format.html
        format.js
      end
    
  end


end