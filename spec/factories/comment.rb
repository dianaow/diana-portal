FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "comment text #{n}" }
    article
    user
  end
end
