module DpdApi
  class Order < Base
    def self.url
      "#{DpdApi.configuration.base_url}/services/order2?wsdl"
    end

    def create_order(params = {})
      method = :create_order
      response(method, params)
    end

    def cancel_order(params = {})
      method = :cancel_order
      response(method, params)
    end

    def order_status(params = {})
      method = :get_order_status
      response(method, params)
    end

    def create_address(params = {})
      method = :create_address
      response(method, params)
    end

    def update_address(params = {})
      method = :update_address
      response(method, params)
    end

    def invoice_file(params = {})
      method = :get_invoice_file
      response(method, params)
    end

    def add_parcels(params = {})
      method = :add_parcels
      response(method, params)
    end

    def remove_parcels(params = {})
      method = :remove_parcels
      response(method, params)
    end
  end
end
