class PagesController < ApplicationController
before_action :authenticate_user!
before_action :set_users

  def home
      @feed = current_user.feed.paginate(page: params[:page], per_page: 20).order("updated_at DESC")

      @featured_article = Article.published
                                 .where('created_at >= ?', 1.week.ago)
                                 .select("articles.id, slug, title, summary, impressions_count, cached_votes_up, updated_at, user_id")
                                 .sorted_by_popular_score
                                 .first

      if @categories.empty? == true
        @recommended = @users.limit(5)
      else
        @recommended = @users.where(id: [@array]).limit(5)
      end
      
      if params[:id]
        @replacement = @users.where('id NOT IN (?)', @recommended).where.not(id: params[:id]).first
        respond_to do |format|
          format.html
          format.js { render action: "home" }
        end
      else
        @recommended
      end
    
  end
  
  def refresh
    @refresh = @users.order('random()').limit(5)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  private
  
  def set_users
    @categories = Category.top_3_visited(current_user)
    
    @array = Category.joins(:articles)
                     .where(categories: {id: @categories.ids})
                     .pluck("DISTINCT articles.user_id")

    @users = User.where.not(id: current_user.self_initiated_friends)
                 .where.not(id: current_user)
                 .top_10_most_authored 
                 .active_users
  end


end