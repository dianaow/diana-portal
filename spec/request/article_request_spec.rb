require "rails_helper"

shared_examples "full access to article index and show pages" do
  
  it "allows access to articles#index" do
    get articles_path
    expect(response.status).to eq(200)
  end
  
  it "allows access to articles#show" do
    get articles_path
    expect(response.status).to eq(200)
  end

end

describe "Public access to articles", type: :request do
    
let!(:user) { FactoryBot.create(:user) }

  before do 
    @article = Article.create(title: 'Test Article', summary: 'Summary of article', description: 'Request spec test', status: "published", user_id: user.id)
  end
  
  it_behaves_like "full access to article index and show pages"

  it "denies access to articles#new" do
    get new_article_path
    expect(response).to redirect_to new_user_session_path
  end

  it "denies access to articles#create" do
    article_attributes = FactoryBot.attributes_for(:article)
    expect {
      post "/articles", params: { article: article_attributes }
    }.to_not change(Article, :count)

    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to articles#edit" do
    get "/articles/test-article/edit"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to articles#update" do
    patch "/articles/test-article"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to articles#destroy" do
    delete "/articles/test-article"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "denies access to articles#draft" do
    get "/drafts"
    expect(response).to redirect_to new_user_session_path
  end
  
  it "allows access to articles#upvote" do
    get "/articles/test-article/upvote", xhr: true
    expect(response.status).to eq(401)
  end
  
  it "allows access to articles#downvote" do
    get "/articles/test-article/upvote", xhr: true
    expect(response.status).to eq(401)
  end
  
end

describe "Logged in access to articles", type: :request do
    
let!(:user) { FactoryBot.create(:user) }

  before do 
    @article = Article.create(title: 'Test Article', summary: 'Summary of article', description: 'Request spec test', status: "published", user_id: user.id)
    login_as(user, :scope => :user)  
  end
  
  it_behaves_like "full access to article index and show pages"

  it "allows access to articles#new" do
    get new_article_path
    expect(response.status).to eq(200)
  end

  it "allows access to articles#create" do
    article_attributes = FactoryBot.attributes_for(:article)
    expect {
      post "/articles", params: { article: article_attributes }
    }.to change(Article, :count).by(1)

    expect(response).to redirect_to "/articles/#{Article.last.friendly_id}"
  end
  
  it "allows access to articles#edit" do
    get "/articles/test-article/edit"
    expect(response.status).to eq(200)
  end
  
  it "allows access to articles#update" do
    article_attributes = FactoryBot.attributes_for(:article, title: "New title")
    patch "/articles/test-article", params: { article: article_attributes }
    expect(response.status).to eq(200)
  end
  
  it "allows access to articles#destroy" do
    delete "/articles/test-article"
    expect(response).to redirect_to "/articles"
    expect(flash[:success]).to eq "Your article was deleted successfully"
  end
  
  it "allows access to articles#draft" do
    get "/drafts"
    expect(response.status).to eq(200)
  end
  
  it "allows access to articles#upvote" do
    get "/articles/test-article/upvote", xhr: true
    expect(response.status).to eq(200)
  end
  
  it "allows access to articles#downvote" do
    get "/articles/test-article/upvote", xhr: true
    expect(response.status).to eq(200)
  end
  
end

describe "Un-authorized access to modify another user's articles", type: :request do
    
let!(:user) { FactoryBot.create(:user) }
let!(:user2) { FactoryBot.create(:user) }

  before do 
    @article = Article.create(title: 'Test Article', summary: 'Summary of article', description: 'Request spec test', status: "published", user_id: user.id)
    login_as(user2, :scope => :user)  
  end
  
  it "denies access to articles#edit" do
    get "/articles/test-article/edit"
    expect(response).to redirect_to root_path
    expect(flash[:error]).to eq "You are not authorized to edit this article"
  end
  
end