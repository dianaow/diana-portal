class PagesController < ApplicationController
before_action :authenticate_user!

def home
    @feed = current_user.feed.paginate(page: params[:page], per_page: 20).order("updated_at DESC")
    respond_to do |format|
      format.html
      format.js
    end
end

end