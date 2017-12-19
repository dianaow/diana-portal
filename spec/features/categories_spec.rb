require 'rails_helper' 
  
describe 'category', type: :feature, js: true do
    
  let!(:user) { FactoryBot.create(:user) }
    
  describe "articles within a category" do
    
    let!(:category) { FactoryBot.create(:category, :with_articles, number_of_articles: 10) }
    
    before do
      @first_listed_articles = Category.first.articles.order("impressions_count DESC").limit(3)
      @next_listed_articles = Category.first.articles.order("impressions_count DESC").limit(3).offset(3)
      login_as(user, :scope => :user)
      visit categories_path
    end
    
    scenario "categories index page can be reached successfully" do
      expect(page).to have_current_path "/categories"
    end

    scenario 'categories are tagged on article show page' do
      visit article_path(Article.last)
      expect(page).to have_link(category.name, href: "/categories/#{category.id}")
    end
    
    scenario "only top 6 most viewed articles are shown within each category" do
      within ".category-xlg" do
        expect(page).to have_css(".panel", count: 6)
      end
    end

    scenario "categorized articles are arranged in descending order of view count" do
      expect( @first_listed_articles.first.title ).to appear_before( @next_listed_articles.last.title )
    end
   
    scenario "user can browse through articles within a category by clicking chevron left and right icon" do
      within ".category-xlg" do
        
        @first_listed_articles.each do |a|
          expect(page).to have_link(a.title, href: "/articles/#{a.friendly_id}", visible: true)
        end
        @next_listed_articles.each do |a|
          expect(page).to have_link(a.title, href: "/articles/#{a.friendly_id}", visible: false)
        end
        
        find(".glyphicon-chevron-right").click
        expect(page).to have_current_path(categories_path)
        
        @first_listed_articles.each do |a|
          expect(page).to have_link(a.title, href: "/articles/#{a.friendly_id}", visible: false)
        end

        @next_listed_articles.each do |a|
          expect(page).to have_link(a.title, href: "/articles/#{a.friendly_id}", visible: true)
        end

      end
    end
    
    scenario "a list of all articles belonging to a category can be found on category show page" do
      visit category_path(category)
      expect(page).to have_css("#content-block", count: 10)
    end
    
  end
  
    
  describe "a list of 6 categories" do
    
    let!(:categories) { FactoryBot.create_list(:category, 6, :with_articles, number_of_articles: 10) }
    
    before do
      @last_category_id = Category.last.id
      login_as(user, :scope => :user)
      visit categories_path
    end
    
    scenario "categories are arranged in created_at descending order" do 
      expect(Category.last.name).to appear_before(Category.find(@last_category_id-1).name)
    end
    
    scenario "only three categories are listed on initial load" do
      expect(page).to have_css(".cat-name-header", count: 3)
      3.times do |x|
        expect(page).to have_content(Category.find(@last_category_id-x).name)
      end
    end
    
    scenario 'user can page in additional three categories by clicking on Load More button' do
      click_on "Load More"
      expect(page).to have_current_path(categories_path)
      3.times do |x|
        expect(page).to have_content(Category.find(@last_category_id-3-x).name)
      end
      expect(page).to have_css(".cat-name-header", count: 6)
    end
   
  end
  
  describe "a category without articles" do
    
    let!(:category_without_article) { FactoryBot.create(:category) }
    
    before do
      login_as(user, :scope => :user)
      visit categories_path
    end
    
    scenario "category name is not displayed if it does not contain any articles" do
      expect(page).to_not have_link(category_without_article, href: "/categories/#{category_without_article}")
    end
    
  end
  
  describe "a category with only 3 articles" do
    
    let!(:category) { FactoryBot.create(:category, :with_articles, number_of_articles: 3) }
    
    before do
      login_as(user, :scope => :user)
      visit categories_path
    end
    
    scenario "chevron left and right icon does not appear if an article only has 3 or less articles" do
      expect(page).to_not have_css(".glyphicon-chevron-right")
      expect(page).to_not have_css(".glyphicon-chevron-left")
    end
    
  end

end
  
