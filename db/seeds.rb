User.create!(name: "Diana Meow", email: "test@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")

User.create!(name: "Test 2", email: "test2@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")

puts "2 Users created"

3.times do |article|
  Article.create!(title: "Ruby on Rails", description: "Beginner level", user_id: User.first.id )
end

puts "3 Ruby on Rails articles have been created"

3.times do |article|
  Article.create!(title: "Ajax", description: "Beginner level", user_id: User.first.id )
end

puts "3 Ajax articles have been created"

3.times do |article|
  Article.create!(title: "Javascript", description: "Beginner level", user_id: User.first.id )
end

puts "3 Javascript articles have been created"