require 'rest-client'

module Droppper

  class << self
    def client
      @client
    end

    def client=(client)
      @client = client
    end
  end

  class Client

    def initialize(options={})
      raise "You must provide an Droppper::Account or a identifier/token pair" unless options[:account] or (options[:token])
      @account          = options[:account]
      @account        ||= Droppper::Account.new(options[:identifier], options[:token])
      @connection       = RestClient::Resource.new("https://api.digitalocean.com", {headers: {"Authorization" => "Bearer #{@account.token}"}})
    end

    def connection
      @connection
    end

    def get(url)
      @connection[url].get accept: :json
    end

    def post(url, params = {})
      r = @connection[url].post params.to_json, {accept: :json, content_type: :json}
    rescue Exception => e
      puts "#{e.inspect}"
      exit!
    end

    def put(url, params = {})
      @connection[url].put params, {accept: :json}
    end

    def patch(url, params = {})
      @connection[url].patch params, {accept: :json}
    end

    def delete(url)
      @connection[url].delete accept: :json
    rescue Exception => e
      puts "#{e.inspect}"
      exit!
    end

  end
end
