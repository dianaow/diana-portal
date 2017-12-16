require 'rails_helper'

describe "Conversation" do
    
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:friend) }
    
    before do
        login_as(user, :scope => :user)
    end
    
    describe 'index', js: true do
        
        before do
          visit conversations_path
        end
        
      	it 'can be reached successfully' do
      	  expect(page.status_code).to eq(200)
      	end
        
        it "create a new conversation", js: true do
          click_on "Compose"
          find("#select2-user_id-container").click
          within('#select2-user_id-results') do
            find("li:nth-child(1)").click
          end
          fill_in 'body', with: "Hello"
          click_on "Send"
          expect(page).to have_css('.chat_area', text: "Hello")
        end
    
    end
    

    describe 'reply', js: true do
        
        before do
           logout(:user)
           login_as(other_user, :scope => :user)
           conversation = Conversation.create(author_id: user.id, receiver_id: other_user.id)
           PersonalMessage.create(conversation_id: conversation.id, user_id: other_user.id, body: "Hello Friend")
           visit conversations_path
        end
        
        it "receiver is able to view conversation in message thread" do
            expect(page).to have_css('.header_sec', text: user.name)
            expect(page).to have_css('.contact_sec', text: "Hello Friend")
        end
        
        it "receiver replies to conversation in message thread" do
            find('.chat-body').click
            fill_in 'body', with: "A reply"
            click_on "Send"
            expect(page).to have_css('.chat_area', text: "A reply")
            expect(page).to have_css('.contact_sec', text: "A reply")
        end
    end

end
