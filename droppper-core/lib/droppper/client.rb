module Droppper
  class Client
    attr_accessor :account

    def initialize(account)
      @account = account
      self.class.default_client = self unless self.class.default_client
    end

    class << self
      def default_client
        @default_client
      end

      def default_client=(client)
        @default_client = client
      end
    end

  end
end
