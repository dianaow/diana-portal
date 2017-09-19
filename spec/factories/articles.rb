FactoryGirl.define do
  factory :article do
    title "Title 1"
    description "Some description"
    status "published"
    user
  end

  factory :second_article, class: "Article" do
    title "Title 2"
    description "Some more content"
    status "published"
    user
  end
end