# encoding: utf-8

module DpdApi
  class Nl < Base
    class << self
      def nl_amount(params = {})
        method = :get_nl_amount
        namespace = :arg0
        response(method, params, namespace: namespace)
      end

      def nl_invoice(params = {})
        method = :get_nl_invoice
        namespace = :arg0
        response(method, params, namespace: namespace)
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/nl?wsdl"
      end
    end
  end
end
