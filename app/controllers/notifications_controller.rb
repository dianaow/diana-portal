class NotificationsController < ApplicationController
    
  def index
      @notifications = Notification.where(recipient: current_user)
  end 
    
  def destroy
    Notification.find(params[:id]).destroy
     respond_to do |format|
      format.html { redirect_to notifications_path }
      format.js   { render :layout => false }
     end
  end

end
