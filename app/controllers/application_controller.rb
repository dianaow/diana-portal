class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  
  before_action :recently_viewed_articles

  def recently_viewed_articles
    session[:article_id] ||= []
    session[:article_id] << params[:id] unless params[:id].nil?
    session[:article_id].delete_at(0) if session[:article_id].size >= 5
  end
  
end
