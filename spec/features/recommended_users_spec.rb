require 'rails_helper'

describe 'feed' do
  
  let!(:other_users) { FactoryGirl.create_list(:user, 10, :with_articles, number_of_articles: 10) }
  let!(:first_user) { FactoryGirl.create(:user, :with_articles, number_of_articles: 5) }
  let!(:second_user) { FactoryGirl.create(:user, :with_articles, number_of_articles: 5)  }
  let!(:third_user) { FactoryGirl.create(:user, :with_articles, number_of_articles: 10) }
  let!(:fourth_user) { FactoryGirl.create(:user, :with_articles, number_of_articles: 15) }
  let!(:fifth_user) { FactoryGirl.create(:user, :with_articles, number_of_articles: 20)  }
  let!(:received_friendship_one) { Friendship.create(user_id: second_user.id, friend_id: third_user.id, accepted: true) }
  let!(:received_friendship_two) { Friendship.create(user_id: first_user.id, friend_id: fourth_user.id, accepted: true) }
  
# Criteria
# Top 3 visited category (if any)
# Top 10 authored articles
# Count of followers 
# Active within the past month
# Limit to 5 users
# Based on factory above, users should be shown on recommended users sidebar in the following order: 5, 3, 2, other user.first, second, third
    
    before do
      login_as(first_user, :scope => :user)
      visit root_path
    end
    
    it "shows recommended users based on the criteria above (new user without any articles/category visited)" do
      expect(page).to have_link(fifth_user.name) 
      expect(page).to have_link(third_user.name) 
    end
    
    
end
    