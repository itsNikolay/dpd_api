# encoding: utf-8

module DpdApi
  class Nl < Base
    class << self
      def nl_amount(params = {})
        response(:get_nl_amount, params, namespace: :arg0)
      end

      def nl_invoice(params = {})
        response(:get_nl_invoice, params, namespace: :arg0)
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/nl?wsdl"
      end
    end
  end
end
