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


8.times do |n| 
  Friendship.create!(user_id: 20-n, friend_id: n+1, accepted: true)
end

puts "5 users with descending number of followers each"


  