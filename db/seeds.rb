User.create!(name: "Diana Meow", email: "test@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
User.create!(name: "Test 2", email: "test2@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
User.create!(name: "Test 3", email: "test3@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
User.create!(name: "Test 4", email: "test4@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")

puts "4 Users created"

Article.create!(title: "Ruby on Rails", description: "Article 1", user_id: User.first.id, status: 1 )
Article.create!(title: "Ajax", description: "Article 2", user_id: User.first.id, status: 1 )
Article.create!(title: "Javascript", description: "Article 3", user_id: User.first.id, status: 1 )
Article.create!(title: "ReactJS", description: "Article 4", user_id: User.first.id, status: 1 )
Article.create!(title: "HTML", description: "Article 5", user_id: User.first.id, status: 1 )
Article.create!(title: "CSS", description: "Article 6", user_id: User.first.id, status: 1 )
Article.create!(title: "Python", description: "Article 7", user_id: User.second.id, status: 1 )
Article.create!(title: "Pyhon", description: "Article 8", user_id: User.second.id, status: 1 )
Article.create!(title: "Python", description: "Article 9", user_id: User.second.id, status: 1 )
Article.create!(title: "SQL", description: "Article 10", user_id: User.second.id, status: 1 )

puts "10 Articles created"