source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'json', '~> 2.1'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 3.0'
gem 'devise'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'autoprefixer-rails'
gem 'faker', :git => 'git://github.com/stympy/faker.git', :branch => 'master'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'bootstrap-will_paginate', '~> 1.0'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'acts_as_votable', '~> 0.10.0'
gem 'impressionist', '~> 1.6'
gem 'friendly_id', '~> 5.2', '>= 5.2.1'
gem 'activerecord-session_store'
gem 'select2-rails', '~> 4.0', '>= 4.0.3'
gem 'transit_rails'
gem 'ransack', '~> 1.8', '>= 1.8.3'
gem 'bootstrap-multiselect-rails'
gem 'jquery-validation-rails'
gem 'ckeditor', '~> 4.2', '>= 4.2.4'
gem 'shoulda'

source 'https://rails-assets.org' do
  gem 'rails-assets-chosen'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.6', '>= 3.6.1'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '2.7.1'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'capybara-screenshot'
  gem 'factory_girl_rails', '~> 4.8'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
