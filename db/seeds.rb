20.times do |n|
  User.create!(name: "Test #{n+1}", 
               email: "test#{n+1}@test.com",
               password: "asdfasdf",
               password_confirmation: "asdfasdf")
end

puts "20 Users created"


Category.create!(name: "Ruby on Rails")
Category.create!(name: "Python")
Category.create!(name: "Ajax")
Category.create!(name: "Javascript")
Category.create!(name: "SQL")

puts "5 Categories created"

20.times do |n|
  Article.create!(title: "Ruby on Rails #{n}",
           description: BetterLorem.p(5, true, false),
           user_id: User.find(2).id,
           status: 1,
           cached_votes_score: 20-n)
end

20.times do |n|
  Article.create!(title: "Python articles #{n}",
           description: BetterLorem.p(5, true, false),
           user_id: User.first.id,
           status: 1)
end


10.times do |n|
  Article.create!(title: "Ajax article #{n}",
           description: BetterLorem.p(5, true, false),
           user_id: User.find(3).id,
           status: 1)
end

10.times do |n|
  Article.create!(title: "Javascript articles #{n}",
           description: BetterLorem.p(5, true, false),
           user_id: User.find(4).id,
           status: 1)
end


puts "60 Articles created"


(1..20).each do |n|
 ArticleCategory.create!(article_id: n, 
                      category_id: 1)
end

(21..40).each do |n|
 ArticleCategory.create!(article_id: n, 
                      category_id: 2)
end    

(41..50).each do |n|
 ArticleCategory.create!(article_id: n, 
                      category_id: 3)
end    

(51..60).each do |n|
 ArticleCategory.create!(article_id: n, 
                      category_id: 4)
end    

(1..10).each do |n|
 ArticleCategory.create!(article_id: n, 
                      category_id: 4)
end    

puts "60 categorized articles (with 10 articles with muliple categories)"