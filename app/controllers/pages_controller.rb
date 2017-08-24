class PagesController < ApplicationController
before_action :authenticate_user!

def home
    @feed = current_user.feed
end
    
end