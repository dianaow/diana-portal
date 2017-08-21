class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]
    
    def create
      @friend = User.find(params[:friend_id])
      @friendship = current_user.friendships.build(friend_id: params[:friend_id])
      if @friendship.save
        flash[:notice] = "Friend requested."
        redirect_back fallback_location: users_path
      else
        flash[:error] = "Unable to request friendship."
        redirect_back fallback_location: root_path
      end
    end

    def update
    @friendship.update!(accepted: true)
      if @friendship.save
        flash[:notice] = "Successfully confirmed friend!"
        redirect_to user_path
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
