FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    name 'Diana Meow'
    email { generate :email }
    password "asdfasdf"
    password_confirmation "asdfasdf"
  end
  
  factory :non_authorized_user, class: "User" do
    name 'NonAuthorized'
    email { generate :email }
    password "asdfasdf"
    password_confirmation "asdfasdf"
  end
  
  factory :friend, class: "User" do
    name 'Friend'
    email { generate :email }
    password "asdfasdf"
    password_confirmation "asdfasdf"
  end

  
end