# encoding: utf-8

module DpdApi
  class LabelPrint < Base
    class << self
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

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/label-print?wsdl"
      end
    end
  end
end
