require 'rails_helper'

RSpec.feature "Searching for User" do
    
    before do
        @user = FactoryGirl.create(:user)
        login_as(@user, :scope => :user)

    end
    
    scenario "with existing name return all those users" do
        visit users_path
        fill_in "search", with: "Diana Meow" 
        click_button "Search"
        expect(page).to have_css('#users', text: @user.name)
        expect(current_path).to eq(users_path)
    end
    
end