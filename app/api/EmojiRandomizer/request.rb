require 'rest-client'

module EmojiRandomizer
    class Request
        BASE_URL = 'https://emojihub.herokuapp.com/api'
        def self.call(http_method:, endpoint:)
            result = RestClient::Request.execute(
                method: http_method,
                url: "#{BASE_URL}#{endpoint}",

                headers: {'Content-Type'=> 'application/json'}
            )
            JSON.parse(result)
        end
    end
end