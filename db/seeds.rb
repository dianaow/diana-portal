require 'faker'

user_array = []  
20.times do |n|
  user_array << User.create!(name: "Test#{n+1}", 
               email: "test#{n+1}@test.com",
               password: "asdfasdf",
               password_confirmation: "asdfasdf",
               last_sign_in_at: "2017-11-18 14:00:00")
end

puts "20 Users created"

category_array = []                                                         
10.times do                                                      
  category_array << Category.create!(name: Faker::ProgrammingLanguage.unique.name)                 
end 

puts "10 Categories created"

user_array.each do |user|
    user_array.length.times do |n|
      Article.create!(title: Faker::Lorem.unique.sentence.chomp('.'),
               summary: Faker::Lorem.unique.sentence(10, false, 10),
               description: Faker::Lorem.paragraph(rand(3..100)),
               user_id: user.id,
               status: 0,
               impressions_count: 30-n,
               cached_votes_score: 30-n)
    end
end

puts "200 Articles created"


20.times do |n|
  ArticleCategory.create!(article_id: n+1, 
                      category_id: 10)
end
20.times do |n|
  ArticleCategory.create!(article_id: n+21, 
                      category_id: 9)
end
9.times do |n|
  ArticleCategory.create!(article_id: n+41, 
                      category_id: n+1)
end

puts "50 categorized articles"


8.times do |n| 
  Friendship.create!(user_id: 20-n, friend_id: n+1, accepted: true)
end

puts "5 users with descending number of followers each"


  