# encoding: utf-8

module DpdApi
  class Calculator < Base
    class << self
      def service_cost(params = {})
        method = :get_service_cost2
        response(method, params)
      end

      def service_cost_by_parcels(params = {})
        method = :get_service_cost_by_parcels2
        response(method, params)
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/calculator2?wsdl"
      end
    end
  end
end
