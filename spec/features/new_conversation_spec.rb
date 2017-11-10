require 'rails_helper'

describe "Conversation" do
    
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:friend) }

    describe 'index' do

      	it 'can be reached successfully' do
      	  login_as(user, :scope => :user)
      	  visit conversations_path 
      	  expect(page.status_code).to eq(200)
      	end
        
        it "create a new conversation", js: true do
        
            in_browser(:one) do
              login_as(user, :scope => :user)
              visit conversations_path
            end
            
            in_browser(:two) do
              login_as(other_user, :scope => :user)
              visit conversations_path
            end
            
            in_browser(:one) do
              click_on "Compose"
              find("#select2-user_id-container").click
              within('#select2-user_id-results') do
                find("li:nth-child(1)").click
              end
              fill_in 'body', with: "Hello"
              click_on "Send"
              expect(page).to have_css('.chat_area', text: "Hello")
              expect(page).to have_css('.header_sec', text: other_user.name)
              expect(page).to have_css('.contact_sec', text: "Hello")
            end
            
            in_browser(:two) do
                expect(page).to have_css('.header_sec', text: user.name)
                expect(page).to have_css('.contact_sec', text: "Hello")
                find('.chat-body').click
                expect(page).to have_css('.chat_area', text: "Hello")
                fill_in 'body', with: "A reply"
                click_on "Send"
                expect(page).to have_css('.chat_area', text: "A reply")
                expect(page).to have_css('.contact_sec', text: "A reply")
            end
            
            in_browser(:one) do
                expect(page).to have_css('.contact_sec', text: "A reply")
                expect(page).to have_css('.chat_area', text: "A reply")
            end
        
        end
    
    end
    


end
