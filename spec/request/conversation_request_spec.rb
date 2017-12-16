require "rails_helper"

describe "Public access to conversations", type: :request do
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  
  it "denies access to conversations#list" do
    get "/conversations/list"
    expect(response).to redirect_to new_user_session_path
  end

  it "denies access to conversations#new" do
    get "/conversations/new"
    expect(response).to redirect_to new_user_session_path
  end

  it "denies access to conversations#index" do
    get conversations_path
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to create a new conversation with a personal message" do
    post "/conversations", xhr: true, params: {
      conversation_id: 1, user_id: user2.id, body: "This is a test"
    }
     expect(response.status).to eq(401)
  end

end

describe "Logged in access to conversations", type: :request do
    
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }

  before do 
    login_as(user, :scope => :user)  
  end
  
  it "denies access to conversations#list" do
    get "/conversations/list"
    expect(response).to redirect_to conversations_path
  end

  it "denies access to conversations#new" do
    get "/conversations/new"
    expect(response).to redirect_to conversations_path
  end
    
  it "allows access to conversations#index" do
    get conversations_path
    expect(response.status).to eq(200)
  end

  it "allows access to create a new conversation with a personal message" do
    post "/conversations", xhr: true, params: {
      conversation_id: 1, user_id: user2.id, body: "This is a test"
    }
    expect(response.status).to eq(200)
  end
  
  
end
