require 'rails_helper'

describe "Comments on article" do
    
    let!(:user) { FactoryGirl.create(:user) }
    let!(:article) { FactoryGirl.create(:article) }

    before do
        login_as(user, :scope => :user)
        visit article_path(article)
    end
    
    describe 'creation', js: true do
            
      it 'displays no comments notice if there are zero comments belonging to article' do
        expect(page).to have_css("#comments-count", text: "This article has 0 comments")
      end
      
      it 'a comment can be created through ajax form submission' do
        fill_in 'comment[content]', with: "Some comments"
        click_on "Add Comment"
        expect(page).to have_css('#comment-content', text: "Some comments")
      end
      
      it 'counts the number of comments belonging to article' do
        fill_in 'comment[content]', with: "Some comments"
        click_on "Add Comment"
        expect(page).to have_css('#comments-count', text: "This article has 1 comment")
      end
      
    end
    
    describe 'edit', js: true do
    
      before do
        fill_in 'comment[content]', with: "Some comments"
        click_on "Add Comment"
      end

      it 'a comment can be edited through ajax' do
        within ".comment-card" do
          click_on "Edit"
          expect(page).to have_css('#comment-content', text: "Some comments")
          fill_in 'comment[content]', with: "Edited comments"
          click_on "Save"
          expect(page).to have_css('#comment-content', text: "Edited comments")
        end
      end
    
    end
    
    describe 'destroy', js: true do
    
      before do
        fill_in 'comment[content]', with: "Some comments"
        click_on "Add Comment"
      end
      
      it 'a comment can be deleted through ajax' do
        within ".comment-card" do
          click_on "Delete"
          wait_for_ajax
        end
        expect(page).to_not have_css('#comment-content', text: "Some comments")
        expect(page).to have_css("#comments-count", text: "This article has 0 comments")
      end

    end
    
end