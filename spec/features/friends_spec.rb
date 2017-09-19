require 'rails_helper'

describe "Submit friend request" do
    
    before do
        @user = FactoryGirl.create(:user)
        @friend = FactoryGirl.create(:user)
        login_as(@user, :scope => :user)
    end
    
    scenario "check that user is not following the other user" do
        visit users_path
        expect(page).to have_css('#users', text: @friend.name)
        expect(page).to have_css('#users', text: @user.name)
        link = "a[href = '/friendships?friend_id=#{@friend.id}']"
        expect(page).to have_selector(link)
    end
    
    scenario "user submits friend request from index page to follow the other user" do
        visit users_path
        link = "a[href = '/friendships?friend_id=#{@friend.id}']"
        find(link).click
        expect(page).to have_css('#buttons', text: "Awaiting request")
    end
end

describe "Accepts friend request" do
        
    before do
        @user = FactoryGirl.create(:user)
        @friend = FactoryGirl.create(:friend)
        @friendship = Friendship.create(user_id: @user.id, friend_id: @friend.id, accepted: false)
        login_as(@friend, :scope => :user)
    end
        
    scenario 'accept or decline options visible to friend' do
        visit followers_path
        expect(page).to have_link("Accept", href: "/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}")
        expect(page).to have_link("Decline", href: "/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}")
    end
    
    scenario 'accepts friend request' do
        visit followers_path
        click_link("Accept", href: "/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}")
        expect(current_path).to eq(users_path)
    end
end     
    
describe "user is following other user" do
    
    before do
        @user = FactoryGirl.create(:user)
        @friend = FactoryGirl.create(:friend)
        @friendship = Friendship.create(user_id: @user.id, friend_id: @friend.id, accepted: true)
        login_as(@user, :scope => :user)
    end
    
    it "unfollow button appears on followers page" do
        visit following_path
        expect(page).to have_css('#following', text: @friend.name)
        href = "/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}"
        expect(page).to have_link("Unfollow", :href => href)
    end
    
    it "unfollow button appears on user show page" do
        visit users_path(@friend)
        href = "/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}"
        expect(page).to have_link("Unfollow", :href => href)
    end

     it "unfollow button appears on user index page" do
        visit users_path
        href = "/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}"
        expect(page).to have_link("Unfollow", :href => href)
    end

    it "user unfollows other user from index page" do
        visit users_path
        link = "a[href = '/friendships/#{@user.friendships.find_by_friend_id(@friend.id).id}'][data-method='delete']"
        find(link).click
        href = "/friendships?friend_id=#{@friend.id}"
        expect(page).to have_link("Follow", :href => href)
    end
end
