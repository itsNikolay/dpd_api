module DpdApi
  class Order < Base
    def self.url
      "#{DpdApi::Configuration::BASE_URL}/services/order2?wsdl"
    end

    def create_order(params = {})
      method = :create_order
      namespace = :orders
      response(method, params, namespace: namespace)
    end

    def cancel_order(params = {})
      method = :cancel_order
      namespace = :orders
      response(method, params, namespace: namespace)
    end

    def get_order_status(params = {})
      method = :get_order_status
      namespace = :order_status
      response(method, params, namespace: namespace)
    end

    def create_address(params = {})
      method = :create_address
      namespace = :address
      response(method, params, namespace: namespace)
    end

    def update_address(params = {})
      method = :update_address
      namespace = :address
      response(method, params, namespace: namespace)
    end

    def get_invoice_file(params = {})
      method = :get_invoice_file
      namespace = :request
      response(method, params, namespace: namespace)
    end

    def add_parcels(params = {})
      method = :add_parcels
      namespace = :parcels
      response(method, params, namespace: namespace)
    end

    def remove_parcels(params = {})
      method = :remove_parcels
      namespace = :parcels
      response(method, params, namespace: namespace)
    end

    def response(method, params = {}, namespace: nil)
      begin
        params    = @auth_params.clone.deep_merge!(params)
        request   = namespace ? { namespace => params } : params
        response  = @client.call(method, message: request)
        namespace = "#{method}_response".to_sym
        resources = response.body[namespace][:return]
        resources = if resources.is_a?(Array)
                      resources
                    else
                      [] << resources
                    end
        { resources: resources }
      rescue Savon::SOAPFault => error
        { errors: error.to_s }
      end
    end
  end
end
