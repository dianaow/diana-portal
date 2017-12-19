FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Test#{n} article" }
    summary "Summary of article"
    description "Description of article."
    user
    after(:create) do |article|
      rand(10).times do
        create(:impression, impressionable: article)
      end
    end

  end

  trait :published do
    status :published
  end

  trait :draft do
    status :draft
  end

  factory :category do
    sequence(:name) { |n| "Name #{n}" }
    after(:create) do |category|
      rand(10).times do
        create(:impression, impressionable: category)
      end
    end
    trait :with_articles do
      transient do
        number_of_articles 1
      end
      after(:create) do |category, evaluator|
        create_list(:article_category, evaluator.number_of_articles, category: category)
      end
    end
  end
  
  factory :impression do
    impressionable factory: :article
    request_hash {Faker::Lorem.characters(10)}
    session_hash {Faker::Lorem.characters(10)}
    ip_address {Faker::Internet.ip_v4_address}
    created_at {Faker::Time.between(DateTime.now - 1, DateTime.now)}
  end
  
  factory :article_category do
    article
    category
  end
  
end