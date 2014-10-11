module DpdApi
  class Nl < Base
    # TODO: Implement namespace
    class << self
      def get_nl_amount(params = {})
        method = :get_nl_amount
        namespace = :arg0
        response(method, params, namespace: namespace)
      end

      def get_nl_invoice(params = {})
        method = :get_nl_invoice
        namespace = :arg0
        response(method, params, namespace: namespace)
      end

      def response(method, params = {}, options = {})
        params    = @auth_params.clone.deep_merge!(params)
        request   = options[:namespace] ? { options[:namespace] => params } : params
        response  = @client.call(method, message: request)
        namespace = "#{method}_response".to_sym
        response.body[namespace][:return]
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/nl?wsdl"
      end
    end
  end
end
