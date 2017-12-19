require 'rails_helper'

describe 'feed' do
  
  let!(:user) { FactoryBot.create(:user) }
  let!(:friend) { FactoryBot.create(:friend) }
  let!(:nonfriend) { FactoryBot.create(:not_friend) }
  let!(:requested_friendship) { Friendship.create(user_id: user.id, friend_id: friend.id, accepted: true) }
  let!(:article_by_user) { Article.create(title: 'Article by user', summary: 'Summary of article', description: 'Description of article', status: "published", user_id: user.id) }
  let!(:article_by_friend) { Article.create(title: 'Article by friend', summary: 'Summary of article', description: 'Description of article', status: "published", user_id: friend.id)  }
  let!(:article_by_nonfriend) { Article.create(title: 'Article by nonfriend', summary: 'Summary of article', description: 'Description of article', status: "published", user_id: nonfriend.id)  }

    before do
      login_as(user, :scope => :user)
      visit root_path
    end
    
    it "shows friends' authored articles on feed" do
      within "#my-feed" do
        expect(page).to have_link(article_by_user.title) 
        expect(page).to have_link(article_by_user.title) 
        expect(page).to have_link(article_by_friend.title) 
        expect(page).to have_link(article_by_friend.title) 
      end
    end
    
    it "does not show unfollowed users' authored articles on feed" do
      within "#my-feed" do
        expect(page).to_not have_link(article_by_nonfriend.title) 
        expect(page).to_not have_link(article_by_nonfriend.title) 
      end
    end
    
end
    