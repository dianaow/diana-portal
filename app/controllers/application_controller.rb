class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  include CurrentUserConcern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_vars
  
  def catch_404
    raise ActionController::RoutingError.new(params[:path])
    raise ActionView::MissingTemplate.new(params[:path])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def set_vars
    @q = Article.ransack(params[:q])
    @articles = @q.result.includes(:categories, :users)
    @notifications = Notification.where(recipient: current_user).order("created_at DESC")
  end
    
  rescue_from ActionController::RoutingError do |exception|
    logger.error 'Routing error occurred'
    redirect_to root_path
  end
  
  rescue_from ActionView::MissingTemplate do |exception|
    logger.error exception.message
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_url
    flash[:error] = 'Oops! The record does not exist.'
  end

    protected
  
    def configure_permitted_parameters
      added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
          
end
