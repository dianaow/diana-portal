FactoryGirl.define do
  
  factory :article do
    title "First test article"
    summary "Summary of first article"
    description "This is the first test article."
    status 1
    user
    
    factory :article_with_comments do
      after(:create) do |article|
        create_list(:comment, 3, article: article)
      end
    end
  
  end

  factory :second_article, class: "Article" do
    title "Second test article"
    summary "Summary of second article"    
    description "This is the second test article."
    status 1
    association :user
  end
  
  factory :draft_article, class: "Article" do
    title "Draft Post Test"
    summary "Summary of draft"    
    description "This is the second test article."
    status 0
    association :user
  end
  
end
