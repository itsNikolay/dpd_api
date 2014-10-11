# encoding: utf-8

module DpdApi
  class Geography < Base
    class << self
      def cities_cash_pay
        method = :get_cities_cash_pay
        response(method)
      end

      def terminals_self_delivery
        method = :get_terminals_self_delivery2
        response(method)
      end

      def parcel_shops(params = {})
        method = :get_parcel_shops
        response(method, params)
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/geography?wsdl"
      end
    end
  end
end
