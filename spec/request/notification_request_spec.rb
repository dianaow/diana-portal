require "rails_helper"

describe "Public access to notifications", type: :request do
    
  it "denies access to notifications#index" do
    get notifications_path
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to notifications#destroy" do
    expect {
      delete "/notifications/1", xhr:true 
    }.to_not change(Notification, :count)
    expect(response).to have_http_status(401)
  end

end

describe "Logged in access to notifications", type: :request do
    
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }

  before do 
    @article = Article.create(title: 'Test Article', summary: 'Summary of article', description: 'Request spec test', status: "published", user_id: user.id)
    @comment = Comment.create(article_id: @article.id, user_id: user.id, content: "This is a test comment")
    @notification = Notification.create!(recipient_id: user.id, actor_id: user2.id, action: "posted", notifiable: @comment)
    login_as(user, :scope => :user)  
  end
  
  it "allows access to notifications#index" do
    get notifications_path
    expect(response.status).to eq(200)
  end
  
  it "allows access to notifications#destroy" do
    expect {
        delete "/notifications/1", xhr:true 
    }.to change(Notification, :count).from(1).to(0)
    expect(response.status).to eq(200)
  end

end
