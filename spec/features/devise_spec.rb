require 'rails_helper'

describe 'login and logout' do
  
  let!(:user) { FactoryBot.create(:user) }

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

describe 'create new user' do
  
  it 'a new user is able to be created from registration page' do
    visit root_path
    click_on "Register"
    expect(current_path).to eq(new_user_registration_path)
    fill_in 'user[email]', with: "tester@test.com"
    fill_in 'user[name]', with: "Tester"
    fill_in 'user[password]', with: "asdfasdf"
    fill_in 'user[password_confirmation]', with: "asdfasdf"
    click_on "Sign up"
    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq(root_path)
  end
  
end