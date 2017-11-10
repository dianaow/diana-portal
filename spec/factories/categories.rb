FactoryGirl.define do
  
  factory :category do
    sequence(:name) { |n| "Name #{n}" }
  end
  
end