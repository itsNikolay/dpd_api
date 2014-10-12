# encoding: utf-8
require "dpd_api/client/response"

module DpdApi
  class Base
    class << self
      def operations
        client.operations
      end

    protected

      def client
        Client::Response.new(self.url)
      end

      def response(method, params = {})
        client.response(method, params)
      end
    end
  end
end
