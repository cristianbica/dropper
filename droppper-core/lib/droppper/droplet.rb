module Droppper
  class Account
    attr_accessor :identifier
    attr_accessor :token

    def initialize(identifier, token)
      @identifier = identifier
      @token      = token
    end
  end
end
