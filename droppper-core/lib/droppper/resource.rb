module Droppper
  class Resource
    def initialize(attributes)
    end

    class << self
      attr_accessor :collection_url
      attr_accessor :collection_name
      attr_accessor :resource_url
      attr_accessor :resource_name

      def find()

      end
    end
  end
end
