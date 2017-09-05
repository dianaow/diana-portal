User.create!(name: "Diana Meow", email: "test@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
User.create!(name: "Test 2", email: "test2@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
User.create!(name: "Test 3", email: "test3@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
User.create!(name: "Test 4", email: "test4@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")

puts "4 Users created"

Category.create!(name: "Ruby on Rails")
Category.create!(name: "Python")
Category.create!(name: "Ajax")
Category.create!(name: "Javascript")
Category.create!(name: "SQL")

puts "5 Categories created"

20.times do |n|
  Article.create!(title: "Ruby on Rails #{n}",
           description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras euismod dolor id felis malesuada, eu vestibulum quam lobortis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean hendrerit nulla vel velit laoreet interdum. Duis ligula quam, congue eget dapibus id, vestibulum a dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque sed auctor diam. Nunc auctor sit amet urna sed ultricies. Praesent id erat id enim fringilla suscipit. Aliquam sit amet commodo lectus. Phasellus eu egestas ex, eu consectetur massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis ultricies nisi sed volutpat luctus. Pellentesque tristique, neque eu condimentum dictum, augue odio pharetra lorem, in iaculis sem dolor non lorem. Nullam facilisis aliquet leo, ut dapibus lectus tristique eu. Duis sollicitudin pulvinar laoreet.",
           user_id: User.find(2).id,
           status: 1,
           impressions_count: 20-n)
end

20.times do |n|
  Article.create!(title: "Python #{n}",
           description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras euismod dolor id felis malesuada, eu vestibulum quam lobortis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean hendrerit nulla vel velit laoreet interdum. Duis ligula quam, congue eget dapibus id, vestibulum a dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque sed auctor diam. Nunc auctor sit amet urna sed ultricies. Praesent id erat id enim fringilla suscipit. Aliquam sit amet commodo lectus. Phasellus eu egestas ex, eu consectetur massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis ultricies nisi sed volutpat luctus. Pellentesque tristique, neque eu condimentum dictum, augue odio pharetra lorem, in iaculis sem dolor non lorem. Nullam facilisis aliquet leo, ut dapibus lectus tristique eu. Duis sollicitudin pulvinar laoreet.",
           user_id: User.first.id,
           status: 1,
           impressions_count: 20-n)
end


10.times do |n|
  Article.create!(title: "Ajax #{n}",
           description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras euismod dolor id felis malesuada, eu vestibulum quam lobortis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean hendrerit nulla vel velit laoreet interdum. Duis ligula quam, congue eget dapibus id, vestibulum a dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque sed auctor diam. Nunc auctor sit amet urna sed ultricies. Praesent id erat id enim fringilla suscipit. Aliquam sit amet commodo lectus. Phasellus eu egestas ex, eu consectetur massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis ultricies nisi sed volutpat luctus. Pellentesque tristique, neque eu condimentum dictum, augue odio pharetra lorem, in iaculis sem dolor non lorem. Nullam facilisis aliquet leo, ut dapibus lectus tristique eu. Duis sollicitudin pulvinar laoreet.",
           user_id: User.first.id,
           status: 1,
           impressions_count: 20-n)
end

10.times do |n|
  Article.create!(title: "Javascript #{n}",
           description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras euismod dolor id felis malesuada, eu vestibulum quam lobortis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean hendrerit nulla vel velit laoreet interdum. Duis ligula quam, congue eget dapibus id, vestibulum a dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque sed auctor diam. Nunc auctor sit amet urna sed ultricies. Praesent id erat id enim fringilla suscipit. Aliquam sit amet commodo lectus. Phasellus eu egestas ex, eu consectetur massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis ultricies nisi sed volutpat luctus. Pellentesque tristique, neque eu condimentum dictum, augue odio pharetra lorem, in iaculis sem dolor non lorem. Nullam facilisis aliquet leo, ut dapibus lectus tristique eu. Duis sollicitudin pulvinar laoreet.",
           user_id: User.first.id,
           status: 1,
           impressions_count: 20-n)
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