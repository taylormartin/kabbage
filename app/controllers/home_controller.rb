class HomeController < ApplicationController
  
  before_action :authenticate_user!, only: :index

  def index
    query = params["query"]
    if query != nil
      @tweets = Twitter.basic_search(query)
    end
  end

end
