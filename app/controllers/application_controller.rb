class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  before_action :set_vars

    def set_vars
        @q = Article.ransack(params[:q])
        @articles = @q.result.includes(:categories, :users)
        @notifications = Notification.where(recipient: current_user).order("created_at DESC").limit(10)
        @notifications_counter = Notification.where(recipient: current_user)
    end
    
end
