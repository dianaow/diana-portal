require "rails_helper"

shared_examples 'comments are found on articles page' do
  
  it "redirects comments#index to root path" do
    get '/articles/test-article/comments'
    expect(response).to redirect_to root_path
  end
  
  it "redirects comments#show to root path" do
    get '/articles/test-article/comments/1'
    expect(response).to redirect_to root_path
  end
    
  it "redirects comments#new to root path" do
    get '/articles/test-article/comments/new'
    expect(response).to redirect_to root_path
  end

end

describe "Public access to comments", type: :request do
    
let!(:user) { FactoryBot.create(:user) }

  before do 
    @article = Article.create(title: 'Test Article', summary: 'Summary of article', description: 'Request spec test', status: "published", user_id: user.id)
    @comment = Comment.create(article_id: Article.last, user_id: user.id, content: "This is a test comment")
  end
  
  it_behaves_like "comments are found on articles page"

  it "denies access to comments#create" do
    expect {
      post "/articles/test-article/comments", params: { comment: @comment }
    }.to_not change(Comment, :count)

    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to comments#edit" do
    get "/articles/test-article/comments/1/edit"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to comments#update" do
    patch "/articles/test-article/comments/1"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to comments#destroy" do
    delete "/articles/test-article/comments/1"
    expect(response).to redirect_to new_user_session_path
  end
  
end

describe "Logged in user access to comments", type: :request do
    
let!(:user) { FactoryBot.create(:user) }

  before do 
    @article = Article.create(title: 'Test Article', summary: 'Summary of article', description: 'Request spec test', status: "published", user_id: user.id)
    @comment = Comment.create(article_id: @article.id, user_id: user.id, content: "This is a test comment")
    login_as(user, :scope => :user)
  end

  it_behaves_like "comments are found on articles page"

  it "full access to comments#create" do
    comment_attributes = FactoryBot.attributes_for(:comment)
    expect {
      post "/articles/test-article/comments", params: { comment: comment_attributes }
    }.to change(Comment, :count).by(1)

    expect(response).to redirect_to "/articles/test-article"
  end
  
  it "full access to comments#edit" do
    get "/articles/test-article/comments/1/edit"
    expect(response).to redirect_to "/articles/test-article"
  end
  
  it "full access to comments#update" do
    comment_attributes = FactoryBot.attributes_for(:comment)
    patch "/articles/test-article/comments/1", params: { comment: comment_attributes }
    expect(response).to redirect_to "/articles/test-article"
  end
  
  it "full access to comments#destroy" do
    delete "/articles/test-article/comments/1"
    expect(response).to redirect_to "/articles/test-article"
  end
  
end
  
