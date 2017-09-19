require 'rails_helper'

describe 'navigate' do
  before do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end
  
  describe 'index' do
    before do
      @article1 = FactoryGirl.create(:article)
      @article2 = FactoryGirl.create(:second_article)
    end
    
  	it 'can be reached successfully' do
  		visit articles_path
  		expect(page.status_code).to eq(200)
  		expect(page).to have_content(@article1.title) 
      expect(page).to have_content(@article1.description) 
      expect(page).to have_content(@article2.title) 
      expect(page).to have_content(@article2.description) 
      expect(page).to have_link(@article1.title) 
      expect(page).to have_link(@article2.title) 
  	end
  end
  
  describe 'new' do
    it 'has a link from the homepage' do
      visit root_path
      click_link("Create New Article")
      expect(page.status_code).to eq(200)
    end
  end

  describe 'creation' do
  	before do
  		visit new_article_path
  	end

  	it 'has a new form that can be reached' do
  		expect(page.status_code).to eq(200)
  	end

  	it 'can be created from new form page' do
      fill_in 'article[title]', with: "Article 1"
      fill_in 'article[description]', with: "Some description"
      click_on "Create Article"
      expect(page).to have_css('#article-description', text: "Some description")
  	end
  end
  
  describe 'edit' do
    before do
      @edit_user = User.create(name: "asdf", email: "asdfasdf@asdf.com", password: "asdfasdf", password_confirmation: "asdfasdf")
      login_as(@edit_user, :scope => :user)
      @edit_post = Article.create(title:"Post to edit", description: "asdf", status: "published", user_id: @edit_user.id)
    end

    it 'can be reached by clicking edit on index page' do
      visit articles_path
      visit "/articles/#{@edit_post.friendly_id}/edit"
      expect(page.status_code).to eq(200)
    end
    
    it 'edit icon is visible to article owner' do
  		visit articles_path
  		expect(page.status_code).to eq(200)
      link = "a[href = '/articles/#{@edit_post.friendly_id}/edit']"
      expect(page).to have_selector(link)
  	end

    it 'can be edited' do
      visit edit_article_path(@edit_post)
      fill_in 'article[title]', with: "Post to edit"
      fill_in 'article[description]', with: "Edited description"
      click_on "Update Article"
      expect(current_path).to eq(article_path(@edit_post))
      expect(page).to have_css('#article-description', text: "Edited description")
    end
    
  	it 'edit icon is not visible to article non-owner' do
  	  logout(:user)
  	  @non_authorized_user = FactoryGirl.create(:user)
      login_as(@non_authorized_user, :scope => :user)
  		visit articles_path
      link = "a[href = '/articles/#{@edit_post.friendly_id}/edit']"
      expect(page).to_not have_selector(link)
    end
    
    it 'cannot be edited by a non authorized user' do
      logout(:user)
      @non_authorized_user = FactoryGirl.create(:user)
      login_as(@non_authorized_user, :scope => :user)
      visit edit_article_path(@edit_post)
      expect(current_path).to eq(root_path)
    end
  end
  
  describe 'draft' do
    before do
      @draft_post = Article.create(title:"Draft Post", description: "asdf", status: "draft", user_id: @user.id)
    end
    
    it 'draft post is not visible on index page' do
      visit articles_path
      expect(page).to_not have_link("Draft Post", href: "/articles/#{@draft_post.id}")
    end
    
    it 'draft post is visible to article owner on drafts page' do
  		visit drafts_path
  		expect(page.status_code).to eq(200)
      link = "a[href = '/articles/#{@draft_post.friendly_id}/edit']"
      expect(page).to have_selector(link)
  	end
  	
  	 it 'draft post is accessible to article owner' do
  		visit article_path(@draft_post)
  		expect(page.status_code).to eq(200)
  	end
  	
  	 it 'draft post is not accessible to non-authorized users' do
  	  logout(:user)
      @non_authorized_user = FactoryGirl.create(:user)
      login_as(@non_authorized_user, :scope => :user)
  		visit article_path(@draft_post)
      expect(current_path).to eq(root_path)
  	end
  	
  end
  
  describe 'category' do
    
    before do
      @category = Category.create(name: "Ruby on Rails")
      @another_category = Category.create(name: "Python")
      @article = Article.create(title:"Categories", description: "asdf", status: "published", user_id: @user.id)
    end
    
    it 'article can have multiple categories' do
      visit edit_article_path(@article)
      check("Ruby on Rails")
      check("Python")
      click_on "Update Article"
      expect(current_path).to eq(article_path(@article))
      expect(page).to have_link("Ruby on Rails", href: "/categories/#{@category.id}")
      expect(page).to have_link("Python", href: "/categories/#{@another_category.id}")

      visit categories_path
      expect(page.status_code).to eq(200)
      expect(page).to have_link("Ruby on Rails", href: "/categories/#{@category.id}")
      expect(page).to have_link("Python", href: "/categories/#{@another_category.id}")
      expect(page).to have_link("Categories", href: "/articles/#{@article.friendly_id}")
    end
  end
end