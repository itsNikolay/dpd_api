# encoding: utf-8

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  nil
end

module DpdApi
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :client_key,
                  :client_number,
                  :base_url,
                  :debug

    attr_reader :auth_params

    def initialize
      @client_key    = ENV['DPD_CLIENT_KEY']    || '123'
      @client_number = ENV['DPD_CLIENT_NUMBER'] || '234'
      @base_url      = 'http://wstest.dpd.ru'
      @debug         = false
    end

    def auth_params
      {
        auth: {
          client_number: client_number,
          client_key:    client_key,
        }
      }
    end
  end
end
