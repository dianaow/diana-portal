require "rails_helper"

shared_examples "full access to category index and show pages" do
  
  it "allows access to categories#index" do
    get categories_path
    expect(response.status).to eq(200)
  end
  
  it "allows access to categories#show" do
    get categories_path
    expect(response.status).to eq(200)
  end

end

shared_examples "denied access to category new, create, edit, show, update, destroy pages" do

  it "denies access to categories#new" do
    get "/categories/new"
    expect(response).to redirect_to root_path
  end

  it "denies access to categories#create" do
    category_attributes = FactoryBot.attributes_for(:category)
    expect {
      post "/categories", params: { category: category_attributes }
    }.to_not change(Category, :count)

    expect(response).to redirect_to root_path
  end
  
  it "denies access to categories#edit" do
    get "/categories/1/edit"
    expect(response).to redirect_to root_path
  end
  
  it "denies access to categories#update" do
    patch "/categories/1"
    expect(response).to redirect_to root_path
  end
  
  it "denies access to categories#destroy" do
    delete "/categories/1"
    expect(response).to redirect_to root_path
  end  

end

describe "Public access to categories", type: :request do
    
  it_behaves_like "full access to category index and show pages"
  it_behaves_like "denied access to category new, create, edit, show, update, destroy pages"

end

describe "Logged in access to categories", type: :request do
    
  let!(:user) { FactoryBot.create(:user) }

  before do 
    login_as(user, :scope => :user)  
  end
  
  it_behaves_like "full access to category index and show pages"
  it_behaves_like "denied access to category new, create, edit, show, update, destroy pages"

end
