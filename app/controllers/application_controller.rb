class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  before_action :set_vars
  around_action :catch_not_found

    def set_vars
        @q = Article.ransack(params[:q])
        @articles = @q.result.includes(:categories, :users)
        @notifications = Notification.where(recipient: current_user).order("created_at DESC").limit(10)
        @notifications_counter = Notification.where(recipient: current_user)
    end
    
    private
    
    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      flash[:error] = 'Oops! The article has been removed and cannot be found.'
    end
        
end
