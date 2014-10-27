# encoding: utf-8
require 'dpd_api/client/response'
require 'dpd_api/debug/inspector'

module DpdApi
  class Base
    class << self
      def operations
        client.client.operations
      end

    protected

      def client
        @client ||= Client::Response.new(self.url)
        Debug::Inspector.new(@client) if DpdApi.configuration.debug
        @client
      end

      def response(method, params = {}, options = {})
        client.response(method, params, options)
      end
    end
  end
end
