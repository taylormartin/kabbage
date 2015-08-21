require 'uri'
require 'base64'

class Wikipedia
  include HTTParty
  base_uri 'https://en.wikipedia.org/w/api.php?'

  class << self

    def basic_search query
      encoded_query = capitalize_and_encode query
      response = get("format=json&action=query&prop=extracts&exintro&explaintext&titles=#{encoded_query}")
      clean_content(response)
    end

  private
    
    def capitalize_and_encode query
      capital_query = query.split.map(&:capitalize).join(' ')
      encoded_query = URI.encode(capital_query)
    end

    def clean_content response
      if response["query"]["pages"].keys[0] == "-1"
        return nil  
      else
        package = {}
        info = response["query"]["pages"].first[1]
        package["content"] = info["extract"]
        package["title"] = info["title"]
        package["pageid"] = info["pageid"]
        package
      end
    end

  end

end
