require 'rails_helper'

def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json # convert to a safe javascript string
  page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
  SCRIPT
end

describe 'navigate' do
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:friend) }
  let!(:article)  { FactoryGirl.create(:article) }
  let!(:second_article) { FactoryGirl.create(:second_article) }
  
  before do
    login_as(user, :scope => :user)
  end
  
  describe 'index' do
    before do
      visit articles_path
    end
    
  	it 'can be reached successfully' do
  		expect(page.status_code).to eq(200)
  	end

    it 'has a list of articles' do
      visit articles_path
      print page.html
      expect(page).to have_link(article.title) 
      expect(page).to have_link(second_article.title) 
  	end
  	
  	it "articles are arranged in created_at descending order" do 
      expect(second_article.title).to appear_before(article.title)
    end
    
  end
  
  describe 'creation' do
  	before do
  		visit new_article_path
  	end

  	it 'has a create new article form that can be reached' do
  		expect(page.status_code).to eq(200)
  	end

  	it 'can be created from new form page' do
      fill_in 'article[title]', with: "First test article"
      fill_in 'article[summary]', with: "Summary of first article"
      fill_in 'article[description]', with: "Description of first test article"
      click_on "Post your article"
      expect(page).to have_content(/Description of first test article/)
  	end
  	
  	 it 'will have a user associated it' do
      fill_in 'article[title]', with: "First test article"
      fill_in 'article[summary]', with: "Summary of first article"
      fill_in 'article[description]', with: "A user is associated with this article"
      click_on "Post your article"
      expect(user.articles.last.description).to eq("A user is associated with this article")
    end
    
  end
  
  describe 'edit' do
    
    before do
      @article_to_edit = Article.create(title: 'Article to edit', summary: 'Summary of article to edit', description: 'Test to edit this article', status: 'published', user_id: user.id)
    end
    
  	it 'edit and delete icon is visible to article owner from index page' do
  		visit articles_path
      within "#article_#{@article_to_edit.id}" do
        expect(page).to have_css('.glyphicon-pencil')
        expect(page).to have_css('.glyphicon-trash')
      end
  	end
  	
    it 'edit and delete link is visible to article owner from show page' do
  		visit article_path(@article_to_edit)
		  expect(page).to have_link("Edit", href: "/articles/#{@article_to_edit.friendly_id}/edit")
		  expect(page).to have_link("Delete", href: "/articles/#{@article_to_edit.friendly_id}")
  	end
  	
  	it 'can be reached by clicking edit on index page' do
      visit articles_path
      visit "/articles/#{@article_to_edit.friendly_id}/edit"
      expect(page.status_code).to eq(200)
    end

    it 'can be edited' do
      visit edit_article_path(@article_to_edit)
      fill_in 'article[description]', with: "Edited description"
      click_on "Post your article"
      expect(current_path).to eq(article_path(@article_to_edit))
      expect(page).to have_content(/Edited description/)
    end
    
  	it 'edit and delete icon is not visible to other users on index page' do
  	  logout(:user)
  	  login_as(other_user, :scope => :user)
  		visit articles_path
      within "#article_#{@article_to_edit.id}" do
        expect(page).to_not have_css('.glyphicon-pencil')
        expect(page).to_not have_css('.glyphicon-trash')
      end
    end
    
    it 'edit and delete link is not visible to other users on show page' do
  	  logout(:user)
  	  login_as(other_user, :scope => :user)
  		visit article_path(@article_to_edit)
		  expect(page).to_not have_link("Edit", href: "/articles/#{@article_to_edit.friendly_id}/edit")
		  expect(page).to_not have_link("Delete", href: "/articles/#{@article_to_edit.friendly_id}")
    end
    
    it 'cannot be edited by a non authorized user' do
      logout(:user)
      login_as(other_user, :scope => :user)
      visit edit_article_path(@article_to_edit)
      expect(current_path).to eq(root_path)
    end
  end
  
  describe 'draft' do
    
    before do
     @draft_article = Article.create(title: 'Draft Article', summary: 'Summary of draft article', description: 'This is a draft article', status: 'draft', user_id: user.id)
    end

    it 'draft post is not visible on index page' do
      visit articles_path
      expect(page).to_not have_link(@draft_article.title) 
    end
    
    it 'draft post is visible to article owner on drafts page' do
  		visit drafts_path
  		expect(page.status_code).to eq(200)
      expect(page).to have_link(@draft_article.title) 
  	end
  	
  	 it 'draft post is accessible to article owner' do
  		visit article_path(@draft_article)
  		expect(page.status_code).to eq(200)
  	end
  	
  	 it 'draft post is not accessible to non-authorized users' do
  	  logout(:user)
      login_as(other_user, :scope => :user)
  		visit article_path(@draft_article)
      expect(current_path).to eq(root_path)
  	end
  end
  
  describe 'delete' do
    
    before do
      logout(:user)
      login_as(other_user, :scope => :user)
      @article_to_delete = Article.create(title: 'Article to delete', summary: 'Summary to article to delete', description: 'Test to delete this article', status: 'published', user_id: other_user.id)
      visit article_path(@article_to_delete)
    end

    it 'can be deleted' do
      expect { 
        within "#article-show-header" do
          find("a[href = '/articles/#{@article_to_delete.friendly_id}']").click
        end
      }.to change(Article, :count).by(-1)
      expect(page.status_code).to eq(200)
    end
  end
  
  describe 'category' do
    
    before do
      @category = FactoryGirl.create(:category) 
      @second_category = FactoryGirl.create(:category) 
      @third_category = FactoryGirl.create(:category) 
      @article_category = ArticleCategory.create(article_id: article.id, category_id: @category.id)
      @another_article_category = ArticleCategory.create(article_id: article.id, category_id: @second_category.id)
    end

    it 'article can have multiple categories tagged on article show page' do
      visit article_path(article)
      expect(page).to have_link(@article_category.category.name, href: "/categories/#{@article_category.category.id}")
      expect(page).to have_link(@another_article_category.category.name, href: "/categories/#{@another_article_category.category.id}")
    end

    it "categories are displayed on categories index page" do
      visit categories_path
      expect(page.status_code).to eq(200)
      expect(page).to have_link(@article_category.category.name, href: "/categories/#{@article_category.category.id}")
      expect(page).to have_link(@another_article_category.category.name, href: "/categories/#{@another_article_category.category.id}")
      expect(page).to have_link(article.title , href: "/articles/#{article.friendly_id}")
    end
    
    it "categorized articles are displayed on categories index page" do
      visit categories_path
      within "#category_#{@category.id}" do
        expect(page).to have_link(article.title , href: "/articles/#{article.friendly_id}")
      end
      within "#category_#{@second_category.id}" do
        expect(page).to have_link(article.title , href: "/articles/#{article.friendly_id}")
      end
    end
    
    it "categories are arranged in created_at descending order" do 
      visit categories_path
      expect(@second_category.name).to appear_before(@category.name)
    end
    
    it "category name is not displayed if it does not contain any articles" do
      visit categories_path
      expect(page).to_not have_link(@third_category.name, href: "/categories/#{@third_category.id}")
    end

  end
  
  describe 'search' do
    
      it "get all records that match the search key words from navbar search" do
      visit articles_path
      find('#nav-search #q_title_cont').set("First\n")
      expect(page).to have_link("First test article", href: "/articles/#{article.friendly_id}")
    end
    
    it "get all records that match the search key words from browse form" do
      visit articles_path
      within "#browse-form" do
        fill_in 'q_title_cont', with: "First"
        fill_in 'q_user_name_cont', with: "Test"
      end
      click_on 'Search'
      expect(page).to have_link("First test article", href: "/articles/#{article.friendly_id}")
    end
    
    it 'filtered records can be sorted' do
    end
  end
  
  describe 'show' do
    it "increase view count if user loads article show page" do
      expect {
        visit article_path(article)
      }.to change { article.reload.impressions_count }.by(1)
    end
  end
  
end