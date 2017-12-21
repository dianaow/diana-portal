require 'rails_helper'

describe 'follow users' do
    
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:friend) }

  describe "Submit friend request", js: true do
      
    before do
      login_as(user, :scope => :user)
    end
    
    it "shows Follow button if current user is not following other user" do
        visit users_path
        expect(page).to have_css('#users', text: other_user.name)
        expect(page).to have_css('#users', text: user.name)
        expect(page).to have_css(".btn-follow")
    end
    
    it "allows user to submit friend request by clicking Follow on users index page, which will change to Pending" do
        visit users_path
        expect(page).to have_content("Friend")
        find(:css, '.btn-follow').click
        expect(page).to have_content("Pending")
    end
    
    it "allows user to submit friend request by clicking Follow on user show page, which will change to Pending" do
        visit user_path(other_user)
        find(:css, '.btn-follow').click
        expect(page).to have_content("Pending")
    end
    
    it "allows user to submit friend request by clicking Follow on user Followers page, which will change to Pending" do
        Friendship.create!(user_id: other_user.id, friend_id: user.id, accepted: true)
        visit followers_path
        click_on "Followers"
        find(:css, '.btn-follow').click
        expect(page).to have_content("Pending")
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
        expect(page).to have_current_path(followers_path)
        expect(page).to have_css(".pending-requests", text: "You have 0 pending friend requests")
        expect(page).to_not have_css(".pending-requests", text: other_user.name)
        expect(page).to_not have_link("Accept")
        expect(page).to_not have_link("Decline")
    end
    
    it 'counts other user as a follower once frend request is accepted' do
        click_on "Accept"
        click_on "Followers"
        expect(page).to have_css(".followers", text: other_user.name)
        expect(page).to have_css(".btn-follow")
        expect(page).to have_content("You have 1 follower")
    end
    
    it 'friend request disappear once user clicks decline' do
        click_on "Decline"
        expect(current_path).to eq(followers_path)
        expect(page).to have_css(".pending-requests", text: "You have 0 pending friend requests")
        expect(page).to_not have_css(".pending-requests", text: other_user.name)
        expect(page).to_not have_link("Accept")
        expect(page).to_not have_link("Decline")
    end
    
    it 'destroys friendship if frend request is declined' do
        click_on "Decline"
        click_on "Followers"
        expect(page).to_not have_css(".followers", text: other_user.name)
        expect(page).to_not have_link("Follow", href: "/friendships?friend_id=#{other_user.id}")
        expect(page).to have_css(".followers", text: "You have 0 followers")
    end
    
  end   
  
  describe "Managing sent friend request", js: true do
      
    let!(:request) { Friendship.create(user_id: user.id, friend_id: other_user.id, accepted: true) }
    let!(:received_request) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: true) }
        
    before do
       login_as(user, :scope => :user)
       visit following_path
    end
    
    it 'shows unfollow button on following page' do
        expect(page).to have_link(other_user.name)
        expect(page).to have_css(".btn-unfollow")
    end
    
    it "friend disappears from following list once user clicks unfollow" do
        find(:css, '.btn-unfollow').click
        expect(current_path).to eq(following_path)
        expect(page).to have_content("You are following 0 people")
    end
    
    it "allows user to unfollow from users index page" do
        visit users_path
        find(:css, '.btn-unfollow').click
        expect(page).to have_css(".btn-follow")
    end
    
    it "allows user to unfollow from user show page" do
        visit user_path(other_user)
        find(:css, '.btn-unfollow').click
        expect(page).to have_content("1 follower")
        expect(page).to have_css(".btn-follow")
    end
    
    it "allows user to unfollow from Followers page" do
        visit followers_path
        click_on "Followers"
        find(:css, '.btn-unfollow').click
        expect(page).to have_css(".btn-follow")
    end
    
    it "ex-friend can be re-followed" do
        find(:css, '.btn-unfollow').click
        visit users_path
        expect(page).to have_css(".btn-follow")
    end
    
  end
  
  describe "Follow status on user index page and user show page", js: true do
      
    let!(:request) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: false) }
        
    before do
       login_as(user, :scope => :user)
    end
    
    it 'shows follow button beside a user which current user has received a friend request from and is currently not following' do
        visit users_path
        expect(page).to have_css(".btn-follow")
        visit user_path(other_user)
        expect(page).to have_css(".btn-follow")
    end
    
    it 'shows follow button beside a user which current user has accepted a friend request from and is currently not following' do
        visit followers_path
        click_on "Accept"
        visit users_path
        expect(page).to have_css(".btn-follow")
        visit user_path(other_user)
        expect(page).to have_css(".btn-follow")
    end
    
    
    it 'shows follow button beside a user which current user has declined a friend request from and is currently not following' do
        visit followers_path
        click_on "Decline"
        visit users_path
        expect(page).to have_css(".btn-follow")
        visit user_path(other_user)
        expect(page).to have_css(".btn-follow")
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
        expect(page).to have_css(".btn-unfollow")
        visit user_path(other_user)
        expect(page).to have_css(".btn-unfollow")
    end
    
    it 'shows unfollow button beside a user which current user has accepted a friend request from and is currently following' do
        visit followers_path
        click_on "Accept"
        visit users_path
        expect(page).to have_css(".btn-unfollow")
        visit user_path(other_user)
        expect(page).to have_css(".btn-unfollow")
    end
    
    
    it 'shows unfollow button beside a user which current user has declined a friend request from and is currently following' do
        visit followers_path
        click_on "Decline"
        visit users_path
        expect(page).to have_css(".btn-unfollow")
        visit user_path(other_user)
        expect(page).to have_css(".btn-unfollow")
    end
    
  end
  
  describe "Pending on user index page and user show page", js: true do
      
    let!(:requested_friendship) { Friendship.create(user_id: user.id, friend_id: other_user.id, accepted: false) }
    let!(:received_friendship) { Friendship.create(user_id: other_user.id, friend_id: user.id, accepted: false) }
        
    before do
       login_as(user, :scope => :user)
    end
    
    it 'shows Pending beside a user which current user has received a friend request from and is currently awaiting a follow back' do
        visit users_path
        expect(page).to have_content("Pending")
        visit user_path(other_user)
        expect(page).to have_content("Pending")
    end
    
    it 'shows Pending beside a user which current user has accepted a friend request from and is currently awaiting a follow back' do
        visit followers_path
        click_on "Accept"
        visit users_path
        expect(page).to have_content("Pending")
        visit user_path(other_user)
        expect(page).to have_content("Pending")
    end
    
    it 'shows Pending beside a user which current user has declined a friend request from and is currently awaiting a follow back' do
        visit followers_path
        click_on "Decline"
        visit users_path
        expect(page).to have_content("Pending")
        visit user_path(other_user)
        expect(page).to have_content("Pending")
    end
    
  end
      
end
