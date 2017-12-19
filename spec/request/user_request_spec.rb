require "rails_helper"

describe "Public access to users", type: :request do
    
  it "denies access to users#index" do
    get users_path
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to users#show" do
    get users_path
    expect(response).to redirect_to new_user_session_path
  end

  it "denies access to users#followers" do
    get "/followers"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to users#following" do
    get "/following"
    expect(response).to redirect_to new_user_session_path
  end

end

describe "Logged in access to users", type: :request do
    
  let!(:user) { FactoryBot.create(:user) }

  before do 
    login_as(user, :scope => :user)  
  end
  
  it "allows access to users#index" do
    get users_path
    expect(response.status).to eq(200)
  end
  
  it "allows access to users#show" do
    get users_path
    expect(response.status).to eq(200)
  end

  it "allows access to users#followers" do
    get "/followers"
    expect(response.status).to eq(200)
  end
  
  it "allows access to users#following" do
    get "/following"
    expect(response.status).to eq(200)
  end

end
