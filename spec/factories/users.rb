FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end
  
  factory :user do
    sequence(:name) { |n| "Test#{n}" }
    email { generate :email }
    password "asdfasdf"
    password_confirmation "asdfasdf"
    
      trait :with_followers do
        transient do
          number_of_followers 1
        end
        after(:create) do |user, evaluator|
          create_list(:friendship, evaluator.number_of_followers, friend: user)
        end
      end
        
      trait :with_articles do
        transient do
          number_of_articles 1
        end
        after(:create) do |user, evaluator|
          create_list(:article, evaluator.number_of_articles, user: user)
        end
      end
      
      trait :last_sign_in_at do
        last_sign_in_at { DateTime.now }
      end

    factory :not_friend do
      name 'NotFriend'
    end
    
    factory :friend do
      sequence(:name) { |n| "Friend#{n}" }
    end
    
  end
  
end