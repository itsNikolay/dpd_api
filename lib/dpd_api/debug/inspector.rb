require 'observer'

module Debug
  class Inspector
    def initialize(client)
      client.add_observer(self)
    end

    def update(url, params, response_body, result)
      p '--------------------------'
      p "SENDING REQUEST TO: #{url}"
      p "WITH PARAMS:        #{params}"
      p "GETTING RESPONSE:   #{response_body}"
      p "RESULT:             #{result}"
      p '--------------------------'
    end
  end
end
