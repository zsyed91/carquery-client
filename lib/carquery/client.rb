require "carquery/client/version"
require 'faraday'
require 'faraday_middleware'

module Carquery
  class Client
    API_VERSION = '0.3'.freeze
    BASE_URL = 'https://www.carqueryapi.com'.freeze

    def initialize(options = {})
      @connection = Faraday::Connection.new(
        BASE_URL,
        headers: {
          'Content-Type' => 'application/json'
        },
        ssl: {
          ca_path: options.fetch(:ca_path, default_config[:ca_path])
        },
      ) do |f|
        f.response :json
      end
    end

    def years
      request(cmd: 'getYears')['Years']
    end

    def makes_for_year(year, us_only = 1)
      request(cmd: 'getMakes', year: year, sold_in_us: us_only)['Makes']
    end

    def models_for_year_and_make(year, make, us_only = 1)
      request(cmd: 'getModels', year: year, make: make, sold_in_us: us_only)['Models']
    end

    private

    def request(params = {})
      response = @connection.get(default_api_endpoint, params)
      response.body
    end

    def default_api_endpoint
      "/api/#{API_VERSION}/"
    end

    def default_config
      { ca_path: '/usr/lib/ssl/certs', }
    end
  end
end
