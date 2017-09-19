require 'rails_helper'

describe "Comments on article" do
    
    before do
        @user = FactoryGirl.create(:user)
        login_as(@user, :scope => :user)
        @article1 = FactoryGirl.create(:article)
        visit article_path(@article1)
    end
    
    scenario 'edit' do
      @comment = Comment.create(content:"Some comments", article_id: @article1.id, user_id: @user.id)
      visit article_path(@article1)
      within('.card-block') do
        click_link("Edit", href: "/articles/#{@article1.friendly_id}/comments/#{@comment.id}/edit")
      end
      fill_in 'comment[content]', with: "Edited comments"
      click_on "Post"
      expect(page).to have_css('.comment-content', text: "Edited comments")
    end
    
     it 'creation' do
      fill_in 'comment[content]', with: "Some comments"
      click_on "Post"
      expect(current_path).to eq(article_path(@article1))
      expect(page).to have_css('.comment-content', text: "Some comments")
    end
  
    
end