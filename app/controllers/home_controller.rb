class HomeController < ApplicationController
  
  before_action :authenticate_user!, only: :index

  # comment on this controller method
  def index
    query = params["query"]
    unless query.nil? || query == "" 
      @tweets = Twitter.basic_search(query)
      @wikipedia = Wikipedia.basic_search(query)
    end
  end

end
