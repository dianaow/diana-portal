require 'rails_helper'

describe 'notifications' do
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:friend) { FactoryGirl.create(:friend) }

  describe 'follow user' , js: true do
    
    before do
      login_as(friend, :scope => :user)
      visit user_path(user)
      click_on "Follow"
      expect(page).to have_content "Awaiting Request"
      logout(:user)
      login_as(user, :scope => :user)
      visit followers_path
    end
    
    it "renders notification on dropdown list with link to user profile" do
  	  find('.notifications .dropdown-toggle').click
      expect(page).to have_css("#notificationList", text: friend.name + " has requested to follow you")
      expect(page).to have_css("#notification-counter", text: "1")
      expect(page).to have_link(user.name)
    end
    
    it "notification received by friend once user accepts the follow request" do
      click_on "Accept"
      expect(page).to_not have_content("Accept")
      logout(:user)
      login_as(friend, :scope => :user)
      visit root_path
  	  find('.notifications .dropdown-toggle').click
      expect(page).to have_css("#notificationList", text: user.name + " has accepted your follow request")
      expect(page).to have_css("#notification-counter", text: "1")
      expect(page).to have_link(user.name)
    end
    
  end
    
end