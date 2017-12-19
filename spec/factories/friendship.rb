FactoryBot.define do
    
    factory :friendship do
      association :friend, :factory => :user
      association :user, :factory => :friend
      accepted true
    end

end