module DpdApi
  class Tracing < Base
    def self.url
      "#{DpdApi::Configuration::BASE_URL}/services/tracing1-1?wsdl"
    end

    def get_states_by_client_order(params = {})
      method = :get_states_by_client_order
      namespace = :request
      response(method, params, namespace: namespace)
    end

    def get_states_by_client_parcel(params = {})
      method = :get_states_by_client_parcel
      namespace = :request
      response(method, params, namespace: namespace)
    end

    def get_states_by_dpd_order(params = {})
      method = :get_states_by_dpd_order
      namespace = :request
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
