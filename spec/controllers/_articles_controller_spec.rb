require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
    
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:article) { FactoryGirl.create(:article) }

  before do
    login_as(user, :scope => :user)
    @article_category = ArticleCategory.create(article_id: article.id, category_id: category.id)
  end
  
    describe 'search' do
    it "get all records that match the search key words" do
        get :search, q: {title_cont: 'First', categories_name_in: 'Python', user_name_cont: 'Test1'}
        expect(page).to include article
    end
    
    it 'filtered records can be sorted' do
    end
  end
  

end