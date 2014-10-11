# encoding: utf-8

module DpdApi
  class Tracing < Base
    class << self
      def states_by_client_order(params = {})
        method = :get_states_by_client_order
        response(method, params)
      end

      def states_by_client_parcel(params = {})
        method = :get_states_by_client_parcel
        response(method, params)
      end

      def states_by_dpd_order(params = {})
        method = :get_states_by_dpd_order
        response(method, params)
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/tracing1-1?wsdl"
      end
    end
  end
end
