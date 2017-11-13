require 'rails_helper'

describe 'navigate' do
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:friend) }

  describe 'index' do
    
    let!(:article) { FactoryGirl.create_list(:article, 2, :published) }

    before do
      login_as(user, :scope => :user)
      visit articles_path
    end
    
  	it 'can be reached successfully' do
  		expect(page.status_code).to eq(200)
  	end

    it 'has a list of articles' do
      visit articles_path
      expect(page).to have_link(Article.first.title) 
      expect(page).to have_link(Article.last.title) 
      screenshot_and_save_page
  	end
  	
  	it "articles are arranged in created_at descending order" do 
      expect(Article.last.title).to appear_before(Article.first.title)
    end
    
    it "increase view count if user loads article show page" do
      expect {
        visit article_path(Article.first)
      }.to change { Article.first.impressions_count }.by(1)
    end
    
  end
  
  describe 'creation' do
    
  	before do
  	  login_as(user, :scope => :user)
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
      @article_to_edit = Article.create(title: 'Article to edit', summary: 'Summary of article to edit', description: 'Test to edit this article', status: "published", user_id: user.id)
      login_as(user, :scope => :user)
    end
    
  	it 'edit and delete icon is visible to article owner from index page' do
  		visit articles_path
  		within "#article_#{@article_to_edit.id} #user-console" do
  		  expect(page).to have_link("", href: "/articles/#{@article_to_edit.friendly_id}/edit")
  		  expect(page).to have_link("", href: "/articles/#{@article_to_edit.friendly_id}")
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
  		within "#article_#{@article_to_edit.id} #user-console" do
  		  expect(page).to_not have_link("", href: "/articles/#{@article_to_edit.friendly_id}/edit")
  		  expect(page).to_not have_link("", href: "/articles/#{@article_to_edit.friendly_id}")
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
     login_as(user, :scope => :user)
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
      @article_to_delete = Article.create(title: 'Article to delete', summary: 'Summary to article to delete', description: 'Test to delete this article', status: "published", user_id: user.id)
      login_as(user, :scope => :user)
    end

    it 'can be deleted by clicking trash icon on index page' do
      visit articles_path
      expect { 
        within "#article_#{@article_to_delete.id} #user-console" do
          find("a[href = '/articles/#{@article_to_delete.friendly_id}']").click
        end
      }.to change(Article, :count).by(-1)
      expect(current_path).to eq(articles_path)
      expect(page).to have_content("Your article was deleted successfully")
    end
    
    it 'can be deleted by clicking trash icon on article show page' do
      visit article_path(@article_to_delete)
      expect { 
          click_on "Delete"
      }.to change(Article, :count).by(-1)
      expect(current_path).to eq(articles_path)
      expect(page).to have_content("Your article was deleted successfully")
    end
    
    it 'redirects user to root path if user tries to locate the article' do
      visit article_path(@article_to_delete)
      click_on "Delete"
      visit article_path(@article_to_delete)
      expect(current_path).to eq(root_path)
    end
    
  end
  
end