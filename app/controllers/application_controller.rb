class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_vars
  around_action :catch_not_found
  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def set_vars
    @q = Article.ransack(params[:q])
    @articles = @q.result.includes(:categories, :users)
    @notifications = Notification.where(recipient: current_user).order("created_at DESC")
  end
    
    private
    
    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      flash[:error] = 'Oops! The article has been removed and cannot be found.'
    end
    
    protected
  
    def configure_permitted_parameters
      added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
          
end
