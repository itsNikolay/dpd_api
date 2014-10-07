module DpdApi
  class Base
    def initialize
      @client = Savon.client(wsdl: self.class.url)
    end

    def operations
      @client.operations
    end

    def response(method, params = {})
      begin
        params    = DpdApi.configuration
                          .auth_params
                          .clone
                          .deep_merge!(params)
        request   = params.blank? ?  params : { request: params  }
        response  = @client.call(method, message: request)
        namespace = "#{method}_response".to_sym
        resources = response.body[namespace][:return]
        resources = if resources.is_a?(Array)
                      resources
                    else
                      [] << resources
                    end
        resources
      rescue Savon::SOAPFault => error
        { errors: error.to_s }
      end
    end
  end
end
