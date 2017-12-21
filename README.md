# Project

This is my project to build a Medium-like website with Rails 5.1.4.
This application is hosted here: [diana-on-rails.herokuapp.com](https://diana-on-rails.herokuapp.com/)

## Features

* Live chat and notification system created with Action Cable. 
* Follow functionality for users
* Search feature with ([Ransack gem](https://github.com/activerecord-hackery/ransack))
* Vote/Like feature with ([acts_as_votable gem](https://github.com/ryanto/acts_as_votable))
 

## Running the tests

This application was tested with the following test environment:
* [RSpec 3.6](http://rspec.info),
* [FactoryBot](https://github.com/thoughtbot/factory_bot),
* [Capybara 2.13](https://github.com/teamcapybara/capybara) configured to work with
* [Capybara-webkit 1.14](https://github.com/thoughtbot/capybara-webkit) 

Output of rspec test documentation found in [rspec.txt](https://github.com/dianameow/diana-portal/blob/master/rspec.txt)

To run all tests:
```
xvfb-run rspec spec --tag js
```

## Built With

* [Ruby on Rails](http://rubyonrails.org/) - The web framework used
* [Postgresql](https://www.postgresql.org/) - The database used
* [Heroku](https://www.heroku.com/) - The web application deployment model used

## Authors

* **Diana Ow** - *Initial work* - [dianameow](https://github.com/dianameow)

