class PagesController < ApplicationController
before_action :authenticate_user!

def home
    @recent_articles = session[:article_id]
    @feed = current_user.feed
end

end