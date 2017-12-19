require 'rails_helper'

describe 'notifications', type: :feature do
  
  let!(:user) { FactoryBot.create(:user) }
  let!(:friend) { FactoryBot.create(:friend) }
  let!(:article) {
    Article.create(title:"To test notifications", summary: "Summary of article", description: "Description of article.", status: "published", user_id: user.id)
  }

  
  describe 'comment', js: true do
    
    before do
      login_as(friend, :scope => :user)
      visit article_path(article)
  		fill_in 'comment[content]', with: "Some comments"
      click_on "Add Comment"
      expect(page).to have_content "Some comments"
      logout(:user)
      login_as(user, :scope => :user)
      visit notifications_path
    end
      
  	it "renders notification on dropdown list with link to commented article" do
  	  find('.notifications .dropdown-toggle').click
      expect(page).to have_css("#notificationList", text: friend.name + " posted a Comment on " + article.title)
      expect(page).to have_css("#notification-counter", text: "1")
      expect(page).to have_link(article.title)
    end
    
    it "render notification on notifiction index page with link to commented article" do
      expect(page).to have_css("#notifications-index-list", text: friend.name + " posted a Comment on " + article.title)
      expect(page).to have_link(article.title)
  	end
  	
  	 it "allows user to delete notification from notification index page" do
      within "#notifications-index-list" do
        find("a[href = '/notifications/1']").click
        expect(page).to_not have_content("#{friend.name} + posted a Comment on + #{article.title}")
      end
      expect(page).to have_css("#notification-counter", text: "0")
    end
     
    it "allows user to delete notification from dropdown list which will simulatenously delete notification on index page" do
      find('.notifications .dropdown-toggle').click
      expect(page).to have_current_path(notifications_path)
      within "#notificationList" do
        find("a[href = '/notifications/1']").click
        expect(page).to_not have_content("#{friend.name} + posted a Comment on + #{article.title}")
      end
      expect(page).to have_css("#notification-counter", text: "0")
    end
  	  
  end
  
  
  describe 'notification not created if article author comments on own article' , js: true do
   
    before do
      login_as(user, :scope => :user)
      visit article_path(article)
      end
   
    it "does not create notification if article's author comments on own article" do
      fill_in 'comment[content]', with: "I am creating a comment on my own article"
      click_on "Add Comment"
      expect(page).to have_content "#{user.name}"
      expect(page).to have_content "I am creating a comment on my own article"
      find('.notifications .dropdown-toggle').click
      expect(page).to_not have_css("#notificationList", text: user.name + " posted a Comment on " + article.title)
      expect(page).to have_css("#notification-counter", text: "0")
    end
   
  end
  
end