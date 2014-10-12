require 'observer'

module Debug
  class Inspector
    def initialize(client)
      client.add_observer(self)
    end

    def update(url, request, response, result)
      p '--------------------------'
      p "SENDING REQUEST TO: #{url}"
      p "WITH PARAMS:        #{request}"
      p "GETTING RESPONSE:   #{response}"
      p "RESULT:             #{result}"
      p '--------------------------'
    end
  end
end
