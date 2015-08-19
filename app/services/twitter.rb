require 'uri'
require 'base64'

class Twitter
  include HTTParty
  base_uri 'https://api.twitter.com'
  debug_output $stderr

  class << self

    def basic_search query
      check_blank_bearer_token
      encoded_query = URI.encode(query) 
      response = request_content(encoded_query)
      if error_check_response(response) == "bad_token"
        refresh_bearer_token
        response = request_content(encoded_query)
      end
      clean_content(response)
    end

  private

    def request_content query_string
      bearer_token = Rails.application.config.custom[:twitter_bearer_token]
      response = get(
        "/1.1/search/tweets.json?q=#{query_string}",
        :headers => {"Authorization" => "Bearer #{bearer_token}"}
      )
    end

    def clean_content raw_content
      clean_content = []
      raw_content["statuses"].each do |status|
        tweet = {}
        tweet["text"] = status['text']
        tweet["user"] = status['user']['screen_name']
        tweet["pic"] = status['user']['profile_image_url']
        clean_content << tweet
      end
      clean_content
    end

    def error_check_response response
      if response["errors"] != nil
        Rails.logger.error "#{response['errors']}"
        if response['errors'][0]['code'] == 89
         "bad_token"
        end
      end
    end

    def check_blank_bearer_token
      bearer_token = Rails.application.config.custom[:twitter_bearer_token]
      refresh_bearer_token if bearer_token == ""
    end

    def refresh_bearer_token
      new_token = request_bearer_token
      Rails.application.config.custom[:twitter_bearer_token] = new_token
    end

    def request_bearer_token
      auth_string = "#{ENV['twitter_api_key']}:#{ENV['twitter_api_secret']}"
      encoded_auth_string = Base64.strict_encode64(auth_string)
      response = post(
        "/oauth2/token",
        :headers => {"Authorization" => "Basic #{encoded_auth_string}",
                     "Content-Type" => "application/x-www-form-urlencoded;charset=UTF-8"},
        :body => "grant_type=client_credentials"
      )
      response["access_token"]
    end

  end

end
