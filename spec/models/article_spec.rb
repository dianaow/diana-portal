require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "Creation" do
  	before do
  		@article = FactoryGirl.create(:article)
  	end

  	it 'can be created' do	
  		expect(@article).to be_valid
  	end

  	it 'cannot be created without a title and description' do
  		@article.title = nil
  		@article.description= nil
  		expect(@article).to_not be_valid
  	end
  end
end