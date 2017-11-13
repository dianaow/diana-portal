require 'rails_helper'

describe 'vote', js: true do
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:article)  { FactoryGirl.create(:article, :published) }

    before do
      login_as(user, :scope => :user)
      visit article_path(article)
    end
    
    it 'has an icon for user to like an article' do
      expect(page).to have_link("", href: "/articles/#{article.id}/upvote")
      expect(page).to have_css("#article-sidebar", text: "0 likes")
    end
    
    it 'allows user to like an article' do
      within "#article-sidebar" do
        find("a[href = '/articles/#{article.id}/upvote']").click
        expect(page).to have_content("1 like")
        expect(page).to have_link("", href: "/articles/#{article.id}/downvote")
      end
    end
    
    it 'allows user to unlike an article, user can only like once' do
      within "#article-sidebar" do
        find("a[href = '/articles/#{article.id}/upvote']").click
        expect(page).to have_content("1 like")
        find("a[href = '/articles/#{article.id}/downvote']").click
        expect(page).to have_content("0 likes")
        expect(page).to have_link("", href: "/articles/#{article.id}/upvote")
      end
    end
    
end