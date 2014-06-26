module Droppper
  class Resource
    class << self
      attr_accessor :collection_url
      attr_accessor :collection_name
      attr_accessor :resource_url
      attr_accessor :resource_name

      def all(options = {})
        collection = Droppper::Collection.new(model: self, per_page: options[:per_page])
        collection.load_next
        collection
      end

      def create(attributes)
        response = Droppper::client.post self.collection_url, attributes
        initialize_from_response(response)
      end

      def destroy(attributes)
        response = Droppper::client.delete self.resource_url%attributes
      end

      def initialize_from_response(response)
        response = JSON.parse(response)
        if response[resource_name]
          new(response[resource_name])
        else
          nil
        end
      end

    end

    attr_accessor :attributes

    def initialize(attributes)
      self.attributes = attributes
      attributes.each do |k,v|
        send :"#{k}=", v if respond_to?(:"#{k}=")
      end
    end

  end
end
