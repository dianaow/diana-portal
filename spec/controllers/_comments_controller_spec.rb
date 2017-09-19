require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

    describe "GET /edit" do
      it "routes to /edit when request is an ajax request" do
        allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(true)
        expect(get: '/edit').to be_routable
      end
    end

end