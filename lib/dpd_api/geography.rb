module DpdApi
  class Geography < Base
    def self.url
      "#{DpdApi::Configuration::BASE_URL}/services/geography?wsdl"
    end

    def cities
      method = :get_cities_cash_pay
      response(method)
    end

    def terminals
      method = :get_terminals_self_delivery2
      response(method, {})
    end

    def parcel_shops(params = {})
      method = :get_parcel_shops
      response(method, params, namespace: :request)
    end

    def parcel_shops_by(params = {})
      method = :get_parcel_shops
      response(method, params)
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
