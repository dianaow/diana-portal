require 'rails_helper'

describe 'feed' do


  let!(:first_user) { FactoryGirl.create(:user) }
  let!(:second_user) { FactoryGirl.create(:user, :with_articles, :with_followers, :last_sign_in_at, number_of_articles: 1, number_of_followers: 8)}
  let!(:third_user) { FactoryGirl.create(:user, :with_articles, :with_followers, :last_sign_in_at, number_of_articles: 10, number_of_followers: 7) }
  let!(:fourth_user) { FactoryGirl.create(:user, :with_articles, :with_followers, :last_sign_in_at, number_of_articles: 10, number_of_followers: 6) }
  let!(:fifth_user) { FactoryGirl.create(:user, :with_articles, :with_followers, :last_sign_in_at, number_of_articles: 15, number_of_followers: 5) }
  let!(:sixth_user) { FactoryGirl.create(:user, :last_sign_in_at, :with_articles, number_of_articles: 15) }
  let!(:seventh_user) { FactoryGirl.create(:user, :last_sign_in_at, :with_followers, number_of_followers: 15) }
  let!(:eigth_user) { FactoryGirl.create(:user, :with_articles, :with_followers, number_of_articles: 15, number_of_followers: 5) }
  let!(:users_list) { FactoryGirl.create_list(:user, 10, :last_sign_in_at, :with_followers, :with_articles, number_of_articles: 5, number_of_followers: 1) }
  let!(:received_friendship_one) { Friendship.create(user_id: first_user.id, friend_id: third_user.id, accepted: true) }
  let!(:category) { FactoryGirl.create(:category, :with_articles, number_of_articles: 1) }
  let!(:article_category) { FactoryGirl.create(:article_category, article: fourth_user.articles.last, category: category) }

# Criteria
# Top 3 visited category (if any)
# Not current user => 2,3,4,5,6,7,8
# Not following => 2,4,5,6,7,8
# Count of followers => 7,2,4,5,8
# Top 10 authored articles => 8,5,4,2
# Active within the past month => 5,4,2
# Limit to 5 users => 5,4,2, 2 other users from users_list

    before do
      login_as(first_user, :scope => :user)
      visit root_path
    end
    
    it "only shows 5 users, if > 5 users meet the selection criteria" do
      within '.recommended-users-list' do
        expect(page).to have_css(".recommended-user", count: 5)
      end
    end
    
    it "shows recommended users based on the criteria above in the following order (new user without any category visited)" do
      within '.recommended-users-list' do
        expect(page).to have_link(fifth_user.name) 
        expect(page).to have_link(fourth_user.name)
        expect(page).to have_link(second_user.name) 
        expect(page).to_not have_link(first_user.name) 
        expect(page).to_not have_link(third_user.name) 
        expect(page).to_not have_link(sixth_user.name) 
        expect(page).to_not have_link(seventh_user.name) 
        expect(page).to_not have_link(eigth_user.name) 
      end
    end
    
    it "shows recommended users based on the criteria above in the following order (with a category visited)" do
      visit categories_path
      within ".cat-name-header" do
        click_on "#{category.name}"
      end
      visit root_path
      within '.recommended-users-list' do
        expect(page).to have_link(fourth_user.name) 
      end
    end
    
    it "click to refresh recommended users list", js: true do
      click_on "Refresh"
      within '.recommended-users-list' do
        expect(page).to_not have_link(fifth_user.name) 
        expect(page).to_not have_link(fourth_user.name)
        expect(page).to_not have_link(second_user.name) 
        expect(page).to_not have_link(first_user.name) 
        expect(page).to_not have_link(third_user.name) 
        expect(page).to_not have_link(sixth_user.name) 
        expect(page).to_not have_link(seventh_user.name) 
        expect(page).to have_css(".recommended-user", count: 5)
      end
    end
    
    
end
    