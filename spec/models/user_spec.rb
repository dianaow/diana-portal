require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creation" do
  	before do
  		@user = User.create(email: "test@test.com", password: "asdfasdf", password_confirmation: "asdfasdf", name: "Tester")
  	end

  	it "can be created" do
  		expect(@user).to be_valid
  	end

  	it "cannot be created without name" do
  		@user.name = nil
  		expect(@user).to_not be_valid
  	end
  end
end