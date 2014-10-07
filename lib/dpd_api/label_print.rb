module DpdApi
  class LabelPrint < Base
    def self.url
      "#{DpdApi::Configuration::BASE_URL}/services/label-print?wsdl"
    end

    def create_label_file(params = {})
      method = :create_label_file
      namespace = :get_label_file
      response(method, params, namespace: namespace)
    end

    def create_label(params = {})
      method = :create_label
      namespace = :get_label
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
