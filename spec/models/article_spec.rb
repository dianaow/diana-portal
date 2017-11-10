require 'rails_helper'
require 'faker'

RSpec.describe Article, type: :model do
  
    user = User.create(name: "Test", email: "test1@test.com", password: "asdfasdf", password_confirmation: "asdfasdf")
  
    subject {
      described_class.new(title: "Title of article", summary: "Summary of article", description: "Description of article", status: "published", user: user)
    }
   
  describe "Validations" do
  	it 'can be created' do	
  		expect(subject).to be_valid
  	end

  	it 'cannot be created without a title' do
  		subject.title = nil
  		expect(subject).to_not be_valid
  	end
  	
  	it 'cannot be created without a summary' do
  		subject.summary = nil
  		expect(subject).to_not be_valid
  	end
  	
  	it 'cannot be created without a description' do
  		subject.description = nil
  		expect(subject).to_not be_valid
  	end
  	
  	it 'cannot be created without a title that is less than 10 characters' do
  		subject.title = Faker::Lorem.characters(9)
  		expect(subject).to_not be_valid
  	end
  	
  	it 'cannot be created without a title that is more than 100 characters' do
  		subject.title = Faker::Lorem.characters(102)
  		expect(subject).to_not be_valid
  	end
  	
  	it 'cannot be created without a summary that is less than 10 characters' do
  		subject.summary = Faker::Lorem.characters(9)
  		expect(subject).to_not be_valid
  	end
  	
  	it 'cannot be created without a summary that is more than 180 characters' do
  		subject.summary = Faker::Lorem.characters(182)
  		expect(subject).to_not be_valid
  	end
  	
  	 it 'cannot be created without a description that is less than 10 characters' do
  		subject.description = Faker::Lorem.characters(9)
  		expect(subject).to_not be_valid
  	end
  end

  describe "Associations" do
        it { should belong_to(:user) }
        it { should have_many(:comments) }
    
  end

  	
end