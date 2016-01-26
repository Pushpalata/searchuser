require "net/http"
require "uri"
class Report

  #Get response from the URL
  def self.get_response(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
  
  def self.get_social_data(query)
    hsh = {}
    hsh["twitter"] = Report.get_twitter_data(query)
    hsh["github"] = Report.get_github_data(query)
    hsh["rubygem"] = Report.get_rubygem_data(query)
    hsh
  end
  
  def self.get_rubygem_data(query)
    data = {}
    #Get user
    user = Report.get_response("https://rubygems.org/api/v1/profiles/#{query}.json")
    unless user["error"].present?
      join_date = user["created_at"].to_date rescue user["created_at"]
      data["user"] = {:handle => user["handle"], :name => user["name"], :email => user["email"], :joining_date => join_date}
      #Get Gems
      data["gems"] = fetch_user_gems(query)
    end
    data
  end
  
  def self.fetch_user_gems(user_name)
    gems = []
    fetch_gems = Report.get_response("https://rubygems.org/api/v1/owners/#{user_name}/gems.json") rescue []
    fetch_gems.each do |ugem|
      gems << {:name => ugem["name"] , :version => ugem["version"].to_s, :info => ugem["info"], :url => ugem["project_uri"], :created_at => ugem["created_at"]}
    end
    gems
  end
  
  def self.get_github_data(query)
    data = {}
    # Github User
    user = Report.get_response("https://api.github.com/users/#{query}")
    unless user["message"].present?
      join_date = user["created_at"].to_date rescue user["created_at"]
      data["user"] = {:handle => user["login"], :name => user["name"], :email => user["email"], :joining_date => join_date, :image_url => user["avatar_url"], :description => user["bio"]}
      # get User Repository
      data["repositories"] = Report.fetch_user_repositories(query)
    end
    data
  end

  def self.fetch_user_repositories(user_name)
    repositories = []
    fetch_repositories = Report.get_response("https://api.github.com/users/#{user_name}/repos") rescue []
    fetch_repositories.each do |repository|
      repositories << {:name => repository["name"] , :description => repository["description"], :url => repository["html_url"], :created_at => repository["created_at"]}
    end
    repositories
  end
  
  # Fetch Data from Twitter
  def self.get_twitter_data(query)
    data = {}
    user = $twitter.user(query) rescue nil
    if user.present?
      join_date = user.created_at.to_date rescue user.created_at
      data["user"] = {:handle => user.screen_name, :name => user.name, :email => "", :joining_date => join_date, :description => user.description}
      data["tweets"] = Report.fetch_user_tweets(user.screen_name) #rescue []
    end
    data
  end

  def self.fetch_user_tweets(user_name)
    tweets = []
    fetch_tweets = $twitter.user_timeline(user_name, :count => 10) rescue []
    fetch_tweets.collect do |tweet|
      user = tweet.user
      tweets << {:uid => tweet.id , :tweet => tweet.full_text, :from_user => user.name, :profile_image_url => user.profile_image_url.to_s, :tweet_at => tweet.created_at}
    end
    tweets
  end
  
end
