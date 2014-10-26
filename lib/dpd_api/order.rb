# encoding: utf-8

module DpdApi
  class Order < Base
    class << self
      def create_order(params = {})
        method = :create_order
        response(method, params, namespace: 'orders')
      end

      def cancel_order(params = {})
        method = :cancel_order
        response(method, params, namespace: 'orders')
      end

      def order_status(params = {})
        method = :get_order_status
        response(method, params, namespace: 'orders')
      end

      def create_address(params = {})
        method = :create_address
        response(method, params, namespace: 'orders')
      end

      def update_address(params = {})
        method = :update_address
        response(method, params, namespace: 'orders')
      end

      # TODO: add :save for file
      # 
      #f = File.new("/tmp/file.pdf", "w")
      #f.write(Base64.decode64(invoice[:file]).force_encoding('UTF-8'))
      #f.close
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

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/order2?wsdl"
      end
    end
  end
end
