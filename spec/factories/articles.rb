FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "Test#{n} article" }
    summary "Summary of article"
    description "Description of article."
    sequence(:impressions_count) { |n| "#{1000-n}" }
    user
  end

  trait :published do
    status :published
  end

  trait :draft do
    status :draft
  end

  factory :category do
    sequence(:name) { |n| "Name #{n}" }

    trait :with_articles do
      transient do
        number_of_articles 1
      end
      after(:create) do |category, evaluator|
        create_list(:article_category, evaluator.number_of_articles, category: category)
      end
    end
  end
  
  factory :article_category do
    article
    category
  end
  
end