require 'rails_helper'

describe 'navigate' do
  
  let!(:user) { FactoryGirl.create(:user) }

  it 'user is able to sign in with username' do
    visit new_user_session_path
    fill_in 'user[login]', with: user.name
    fill_in 'user[password]', with: user.password
    click_on "Log in"
    expect(page).to have_content "Signed in successfully"
  end
  
  it 'user is able to sign in with username' do
    visit new_user_session_path
    fill_in 'user[login]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on "Log in"
    expect(page).to have_content "Signed in successfully"
  end

      
  it 'user is able to logout' do
    login_as(user, :scope => :user)
    visit root_path
    find('.my_menu .dropdown-toggle').click
    click_on "Logout"
    expect(page).to have_content "Signed out successfully"
  end
  

  
    
end