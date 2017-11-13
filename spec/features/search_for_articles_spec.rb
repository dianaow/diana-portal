require 'rails_helper'

describe 'search' do
      
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:friend) }
  let!(:article)  { FactoryGirl.create(:article) }
  let!(:second_article) { FactoryGirl.create(:second_article) }
  
  before do
    login_as(user, :scope => :user)
  end
  
    it "get all records that match the search key words from navbar search" do
      visit articles_path
      find('#nav-search #q_title_cont').set("First\n")
      expect(page).to have_link("First test article", href: "/articles/#{article.friendly_id}")
    end
    
    it "get all records that match the search key words from browse form" do
      visit articles_path
      within "#browse-form" do
        fill_in 'q_title_cont', with: "First"
        fill_in 'q_user_name_cont', with: "Test"
      end
      click_on 'Search'
      expect(page).to have_link("First test article", href: "/articles/#{article.friendly_id}")
    end
    
    it 'filtered records can be sorted' do
    end

end