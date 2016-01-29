require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
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

  #should check data fetch from github
  describe 'Fetch data from github' do
    it 'returns data from github' do
      get :index, { :user_name => "Pushpalata"}
      response = Net::HTTP.get_response(URI("https://api.github.com/users/#{params[:user_name]}"))
      # Check if it is hit right url
      assert_match /api.github.com/, response.body
    end
    
    it 'should be json response' do
      get :index, { :user_name => "Pushpalata"}
      response = Net::HTTP.get_response(URI("https://api.github.com/users/#{params[:user_name]}"))
      # the response should be in json format
      expect(response.content_type).to eq "application/json"
    end
  end
  
  #should check data fetch from rubygem
  describe 'Fetch data from rubygem' do
    it 'returns data from rubygem' do
      get :index, { :user_name => "Pushpalata"}
      response = Net::HTTP.get_response(URI("https://rubygems.org/api/v1/profiles/#{params[:user_name]}.json"))
      # Check if it is hit right url
      assert_match /rubygems.org/, response.body
    end
    
    it 'should be json response' do
      get :index, { :user_name => "Pushpalata"}
      response = Net::HTTP.get_response(URI("https://rubygems.org/api/v1/profiles/#{params[:user_name]}.json"))
      # the response should be in json format
      expect(response.content_type).to eq "application/json"
    end
  end
  
end

