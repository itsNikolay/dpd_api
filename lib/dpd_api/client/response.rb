require 'savon'

module DpdApi
  module Client
    class Response
      def initialize(url)
        @client = Savon.client(wsdl: url)
      end

      def response(method, params = {}, options = {})
        builder = ResourceBuilder.new(@client, method, params, options)
        builder.resources
      rescue Savon::SOAPFault => error
        { errors: error.to_s }
      end

      private

      class ResourceBuilder
        def initialize(client, method, params = {}, options = {})
          @client  = client
          @method  = method
          @namespace = options.delete(:namespace)
          @merged_params = merge_auth_params(params)
        end

        def resources
          namespace = "#{@method}_response".to_sym
          resources = response.body[namespace][:return]
          resources.is_a?(Array) ? resources : [] << resources
        end

        private

        def merge_auth_params(params = {})
          auth_params = DpdApi.configuration.auth_params.clone
          auth_params.deep_merge!(params)
        end

        def response
          @client.call(@method, message: request)
        end

        def request
          namespace = @namespace || :request
          @merged_params.blank? ? @merged_params : { namespace => @merged_params  }
        end
      end
    end
  end
end
