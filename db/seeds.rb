require 'faker'

user_array = []  
20.times do |n|
  user_array << User.create!(name: "Test#{n+1}", 
               email: "test#{n+1}@test.com",
               password: "asdfasdf",
               password_confirmation: "asdfasdf")
end

puts "20 Users created"

category_array = []                                                         
10.times do                                                      
  category_array << Category.create!(name: Faker::ProgrammingLanguage.unique.name)                 
end 

puts "10 Categories created"

user_array.each do |user|
    10.times do |n|
      Article.create!(title: Faker::Lorem.unique.sentence(10).chomp('.'),
               summary: Faker::Lorem.unique.paragraph(rand(2..4)),
               description: Faker::Lorem.paragraph(rand(3..100)),
               user_id: User.find(n+1).id,
               status: 1,
               impressions_count: 10-n,
               cached_votes_score: 10-n)
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