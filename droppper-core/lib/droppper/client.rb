require 'rest-client'
require 'redis'
require 'redis-namespace'

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
      $redis ||= Redis::Namespace.new redis: Redis.new, namespace: "droppper-http-cache"
      debug "#{self.class.name}#GET #{url}"
      key = Digest::MD5.hexdigest(url)
      @connection[url].get accept: :json
    end

    def post(url, params = {})
      debug "#{self.class.name}#POST #{url} with: #{params.inspect}"
      r = @connection[url].post params.to_json, {accept: :json, content_type: :json}
    rescue Exception => e
      puts "#{e.inspect}"
      exit!
    end

    def put(url, params = {})
      debug "#{self.class.name}#PUT #{url} with: #{params.inspect}"
      @connection[url].put params.to_json, {accept: :json, content_type: :json}
    rescue Exception => e
      puts "#{e.inspect}"
      exit!
    end

    def delete(url)
      debug "#{self.class.name}#DELETE #{url}"
      @connection[url].delete accept: :json
    rescue Exception => e
      puts "#{e.inspect}"
      exit!
    end

    protected
      def debug(msg)
        #puts msg
      end

  end
end
