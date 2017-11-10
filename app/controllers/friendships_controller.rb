class FriendshipsController < ApplicationController

  before_action :set_friendship, only: [:show, :edit, :update, :destroy]
    
    def create
      @friendship = current_user.friendships.build(friend_id: params[:friend_id])
      @friend = @friendship.friend
      if @friendship.save
        respond_to do |format|
          format.html { redirect_back fallback_location: users_path, :flash => { :success => "You have sent a friend request." } }
          format.js 
        end
        Notification.create!(recipient: @friendship.friend, actor: @friendship.user, action: "requested", notifiable: @friendship)
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: users_path, :flash => { :error => "Unable to request friendship." } }
          format.js
        end
      end
    end

    def update
    @friendship.update(accepted: true)
    @friend = @friendship.friend
    @requested_friendship = @friendship.user
      if @friendship.save
        respond_to do |format|
          format.html { redirect_back fallback_location: followers_path, :flash => { :success => "Successfully confirmed friend!" } }
          format.js  
        end
        Notification.create!(recipient: @friendship.user, actor: @friendship.friend, action: "accepted", notifiable: @friendship)
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: followers_path, :flash => { :error => "Sorry! Could not confirm friend!" } }
          format.js
        end
      end
    end

    def destroy
      @follow = @friendship.friend
      @requested_friendship = @friendship.user
      if @friendship.destroy
        if @friendship.accepted? == true
          respond_to do |format|
            format.html { redirect_to followers_path, :flash => { :success =>  "You have unfollowed #{@friendship.user.name}."} }
            format.js { render action: "destroy_friendship" }
          end
        else
          respond_to do |format|
            format.html { redirect_to followers_path, :flash => { :success =>  "You have declined #{@friendship.user.name}'s follow request."} }
            format.js { render action: "decline_friendship" }
          end
        end
      else
        flash[:error] = "Sorry! Could not unfollow user/decline follow request!"
        redirect_back fallback_location: root_path
      end
    end
    
    private

    def set_friendship
      @friendship = Friendship.find_by(id: params[:id])
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id, :user_id, :status)
    end

end
