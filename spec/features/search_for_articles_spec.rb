require 'rails_helper'

describe 'search' do
      
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:friend) }
  let!(:other_articles)  { FactoryBot.create_list(:article, Article.per_page / 2) }
  
  before do
    login_as(user, :scope => :user)
    @article1, @article2 = [other_articles.sample, other_articles.sample]
    @article_one_title = @article1.title.split(" ").first
    @author = @article1.user.name
    visit articles_path
  end
  
    it "get all records that match the search key words from navbar search" do
      visit articles_path
      find('#article_search #q_title_cont').set("#{@article_one_title}\n")
      expect(page).to have_link("#{@article1.title}", href: "/articles/#{@article1.friendly_id}")
    end
    
    it "get all records that match the search key words from browse form" do
      visit articles_path
      within "#form" do
        fill_in 'q_title_cont', with: "#{@article_one_title}"
        fill_in 'q_user_name_cont', with: "#{@author}"
      end
      click_on 'Search'
      expect(page).to have_link("#{@article1.title}", href: "/articles/#{@article1.friendly_id}")
    end
    
    it 'filtered records can be sorted' do
    end

end