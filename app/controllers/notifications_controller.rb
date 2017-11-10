class NotificationsController < ApplicationController
    
  before_action :authenticate_user!
    
  def index
     @notifications = Notification.where(recipient: current_user).order('created_at desc')
  end 
    
  def destroy
    @notification = current_user.notifications.find(params[:id])
    if @notification.destroy
      respond_to do |format|
        format.html { redirect_to notifications_path, :flash => { :success =>  "Successfully deleted notification" } }
        format.js  
      end
    else
     respond_to do |format|
        format.html { redirect_to notifications_path, :flash => { :error => "Unable to delete notification"} }
        format.js
      end
    end
  end

end
