require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end
  
  describe "responds to" do
    it "responds to html by default" do
      get :index
      expect(response.content_type).to eq "text/html"
    end

    it "responds to XLS" do
      get :index, { :user_name => "test", :format => :xls }
      expect(response.content_type).to eq "application/xls"
    end
  end
  
  describe "should search for user" do
    get :index, { :user_name => "test" }
    assert_response :success
  end
  
end
