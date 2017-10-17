class FriendshipsController < ApplicationController

  before_action :set_friendship, only: [:show, :edit, :update, :destroy]
    
    def create
      @friendship = current_user.friendships.build(friend_id: params[:friend_id])
      if @friendship.save
        flash[:notice] = "Friend requested."
        Notification.create!(recipient: @friendship.friend, actor: @friendship.user, action: "requested", notifiable: @friendship)
        redirect_back fallback_location: users_path
      else
        flash[:error] = "Unable to request friendship."
        redirect_back fallback_location: root_path
      end
    end

    def update
    @friendship.update(accepted: true)
      if @friendship.save
        flash[:notice] = "Successfully confirmed friend!"
        Notification.create!(recipient: @friendship.user, actor: @friendship.friend, action: "accepted", notifiable: @friendship)
        redirect_to followers_path
      else
        flash[:notice] = "Sorry! Could not confirm friend!"
        redirect_back fallback_location: root_path
      end
    end

    def destroy
      @friendship.destroy
      flash[:notice] = "Removed friendship."
      redirect_back fallback_location: root_path
    end
    
    def show
      @articles = @friendship.friend.articles
    end
    
      private

    def set_friendship
      @friendship = Friendship.find_by(id: params[:id])
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id, :user_id, :status)
    end
end
