module DpdApi
  class Nl < Base
    def self.url
      "#{DpdApi::Configuration::BASE_URL}/services/nl?wsdl"
    end

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

    def response(method, params = {}, namespace: nil)
      params    = @auth_params.clone.deep_merge!(params)
      request   = namespace ? { namespace => params } : params
      response  = @client.call(method, message: request)
      namespace = "#{method}_response".to_sym
      response.body[namespace][:return]
    end
  end
end
