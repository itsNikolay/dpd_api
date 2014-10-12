# encoding: utf-8

module DpdApi
  class LabelPrint < Base
    class << self
      def create_label_file(params = {})
        response(:create_label_file, params, namespace: :get_label_file)
      end

      def create_label(params = {})
        response(:create_label, params, namespace: :get_label)
      end

      protected

      def url
        "#{DpdApi.configuration.base_url}/services/label-print?wsdl"
      end
    end
  end
end
