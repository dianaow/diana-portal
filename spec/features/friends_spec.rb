require 'rails_helper'

describe 'follow users' do
    
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:friend) }

  describe "Submit friend request", js: true do
      
    before do
      login_as(user, :scope => :user)
    end
    
    it "shows Follow button if current user is not following other user" do
        visit users_path
        expect(page).to have_css('#users', text: other_user.name)
        expect(page).to have_css('#users', text: user.name)
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
    end
    
    it "allows user to submit friend request by clicking Follow button on users index page, which will change to Awaiting Request" do
        visit users_path
        click_on "Follow"
        expect(page).to have_content("Awaiting Request")
    end
    
    it "allows user to submit friend request by clicking Follow button on user show page, which will change to Awaiting Request" do
        visit user_path(other_user)
        click_on "Follow"
        expect(page).to have_content("Awaiting Request")
    end
    
  end

  describe "Managing received friend request", js: true do
      
    let!(:request) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: false) }
        
    before do
       login_as(user, :scope => :user)
       visit followers_path
    end
        
    it 'shows accept or decline options to friend' do
        expect(page).to have_link(other_user.name)
        expect(page).to have_link("Accept")
        expect(page).to have_link("Decline")
        expect(page).to have_css(".pending-requests", text: "You have 1 pending friend request")
    end
    
    it 'friend request disappear once user clicks accept' do
        click_on "Accept"
        wait_for_ajax
        expect(current_path).to eq(followers_path)
        expect(page).to have_css(".pending-requests", text: "You have 0 pending friend requests")
        expect(page).to_not have_css(".pending-requests", text: other_user.name)
        expect(page).to_not have_link("Accept")
        expect(page).to_not have_link("Decline")
    end
    
    it 'counts other user as a follower once frend request is accepted' do
        click_on "Accept"
        wait_for_ajax
        click_on "Followers"
        expect(page).to have_css(".followers", text: other_user.name)
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
        expect(page).to have_content("You have 1 follower")
    end
    
    it 'friend request disappear once user clicks decline' do
        click_on "Decline"
        wait_for_ajax
        expect(current_path).to eq(followers_path)
        expect(page).to have_css(".pending-requests", text: "You have 0 pending friend requests")
        expect(page).to_not have_css(".pending-requests", text: other_user.name)
        expect(page).to_not have_link("Accept")
        expect(page).to_not have_link("Decline")
    end
    
    it 'destroys friendship if frend request is declined' do
        click_on "Decline"
        wait_for_ajax
        click_on "Followers"
        expect(page).to_not have_css(".followers", text: other_user.name)
        expect(page).to_not have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
        expect(page).to have_css(".followers", text: "You have 0 followers")
    end
    
  end   
  
  describe "Managing sent friend request", js: true do
      
    let!(:request) { Friendship.create(user_id: user.id, friend_id: other_user.id, accepted: true) }
        
    before do
       login_as(user, :scope => :user)
       visit following_path
    end
    
    it 'shows unfollow button on following page' do
        expect(page).to have_link(other_user.name)
        expect(page).to have_link("Unfollow")
    end
    
    it "friend disappears from following list once user clicks unfollow" do
        click_on "Unfollow"
        expect(current_path).to eq(following_path)
        expect(page).to have_content("You are following 0 people")
    end
    
    it "ex-friend can be re-followed" do
        click_on "Unfollow"
        wait_for_ajax
        visit users_path
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
    end
    
  end
  
  describe "Follow status on user index page and user show page", js: true do
      
    let!(:request) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: false) }
        
    before do
       login_as(user, :scope => :user)
    end
    
    it 'shows follow button beside a user which current user has received a friend request from and is currently not following' do
        visit users_path
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
        visit user_path(other_user)
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
    end
    
    it 'shows follow button beside a user which current user has accepted a friend request from and is currently not following' do
        visit followers_path
        click_on "Accept"
        wait_for_ajax
        visit users_path
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
        visit user_path(other_user)
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
    end
    
    
    it 'shows follow button beside a user which current user has declined a friend request from and is currently not following' do
        visit followers_path
        click_on "Decline"
        wait_for_ajax
        visit users_path
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
        visit user_path(other_user)
        expect(page).to have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
    end
  end
  
  
  describe "Unfollow status on user index page and user show page", js: true do
      
    let!(:requested_friendship) { Friendship.create(user_id: user.id, friend_id: other_user.id, accepted: true) }
    let!(:received_friendship) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: false) }
        
    before do
       login_as(user, :scope => :user)
    end
    
    it 'shows unfollow button beside a user which current user has received a friend request from and is currently following' do
        visit users_path
        expect(page).to have_link("Unfollow", href: "/friendships/#{user.friendships.find_by_friend_id(other_user.id).id}")
        visit user_path(other_user)
        expect(page).to have_link("Unfollow", href: "/friendships/#{user.friendships.find_by_friend_id(other_user.id).id}")
    end
    
    it 'shows unfollow button beside a user which current user has accepted a friend request from and is currently following' do
        visit followers_path
        click_on "Accept"
        wait_for_ajax
        visit users_path
        expect(page).to have_link("Unfollow", href: "/friendships/#{user.friendships.find_by_friend_id(other_user.id).id}")
        visit user_path(other_user)
        expect(page).to have_link("Unfollow", href: "/friendships/#{user.friendships.find_by_friend_id(other_user.id).id}")
    end
    
    
    it 'shows unfollow button beside a user which current user has declined a friend request from and is currently following' do
        visit followers_path
        click_on "Decline"
        wait_for_ajax
        visit users_path
        expect(page).to have_link("Unfollow", href: "/friendships/#{user.friendships.find_by_friend_id(other_user.id).id}")
        visit user_path(other_user)
        expect(page).to have_link("Unfollow", href: "/friendships/#{user.friendships.find_by_friend_id(other_user.id).id}")
    end
    
  end
  
  describe "Awaiting request on user index page and user show page", js: true do
      
    let!(:requested_friendship) { Friendship.create(user_id: user.id, friend_id: other_user.id, accepted: false) }
    let!(:received_friendship) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: false) }
        
    before do
       login_as(user, :scope => :user)
    end
    
    it 'shows Awaiting Request beside a user which current user has received a friend request from and is currently awaiting a follow back' do
        visit users_path
        expect(page).to have_content("Awaiting Request")
        visit user_path(other_user)
        expect(page).to have_content("Awaiting Request")
    end
    
    it 'shows Awaiting Request beside a user which current user has accepted a friend request from and is currently awaiting a follow back' do
        visit followers_path
        click_on "Accept"
        wait_for_ajax
        visit users_path
        expect(page).to have_content("Awaiting Request")
        visit user_path(other_user)
        expect(page).to have_content("Awaiting Request")
    end
    
    it 'shows Awaiting Request beside a user which current user has declined a friend request from and is currently awaiting a follow back' do
        visit followers_path
        click_on "Decline"
        wait_for_ajax
        visit users_path
        expect(page).to have_content("Awaiting Request")
        visit user_path(other_user)
        expect(page).to have_content("Awaiting Request")
    end
    
  end
      
end
