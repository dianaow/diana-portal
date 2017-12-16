require "rails_helper"

describe "Public access to friendships", type: :request do
    
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  
  before do 
    @received_request = Friendship.create(user_id: user2.id, friend_id: user.id) 
  end
    
  it "allows access to friendships#create" do
    expect {
      post "/friendships", params: { user_id: user2.id, friend_id: user.id }, xhr: true
    }.to_not change(Friendship, :count)
    expect(response.status).to eq(401)
  end
  
  it "allows access to friendships#update" do
    expect {
        patch "/friendships/1", params: { accepted: true }, xhr: true
    }.to_not change(Friendship.where(accepted: true), :count)
    expect(response.status).to eq(401)
  end

  it "allows access to friendships#destroy" do
    expect {
        delete "/friendships/1", xhr: true
    }.to_not change(Friendship, :count)
   expect(response.status).to eq(401)
  end
  
    it "allows access to friendships#create" do
    expect {
      post "/friendships", params: { user_id: user2.id, friend_id: user.id }
    }.to_not change(Friendship, :count)
    expect(response).to redirect_to new_user_session_path
  end
  
  it "allows access to friendships#update" do
    expect {
        patch "/friendships/1", params: { accepted: true }
    }.to_not change(Friendship.where(accepted: true), :count)
    expect(response).to redirect_to new_user_session_path
  end

  it "allows access to friendships#destroy" do
    expect {
        delete "/friendships/1"
    }.to_not change(Friendship, :count)
    expect(response).to redirect_to new_user_session_path
  end
  
end

describe "Logged in access to friendships", type: :request do
    
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }

  before do 
    @received_request = Friendship.create(user_id: user2.id, friend_id: user.id) 
    login_as(user, :scope => :user)  
  end
  
  it "allows access to friendships#create" do
    expect {
      post "/friendships", params: { user_id: user2.id, friend_id: user.id }, xhr: true
    }.to change(Friendship, :count).by(1)
    expect(response.status).to eq(200)
  end
  
  it "allows access to friendships#update" do
    expect {
        patch "/friendships/1", params: { accepted: true }, xhr: true
    }.to change(Friendship.where(accepted: true), :count).from(0).to(1)
    expect(response.status).to eq(200)
  end

  it "allows access to friendships#destroy" do
    expect {
        delete "/friendships/1", xhr: true
    }.to change(Friendship, :count).from(1).to(0)
    expect(response.status).to eq(200)
  end
  

end
