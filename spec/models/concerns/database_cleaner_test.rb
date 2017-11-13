require 'rails_helper'

describe "db_cleaner" do
    
    let!(:article) { FactoryGirl.create(:article) }

    it "first test" do
      expect(Article.all.count).to eq(1)
      expect(Article.last.id).to eq(1)
    end
    
    it "should clean db" do
      expect(Article.all.count).to eq(1)
      expect(Article.last.id).to eq(1)
    end
    
end