module Droppper
  class Resource
    class << self
      attr_accessor :collection_url
      attr_accessor :collection_name
      attr_accessor :resource_url
      attr_accessor :resource_name

      def all(options = {})
        collection = Droppper::Collection.new(model: self, per_page: options[:per_page])
        collection.fetch
        collection
      end

      def find(id_or_attributes)
        attributes = id_or_attributes.is_a?(Hash) ? id_or_attributes : {id: id_or_attributes}
        response = Droppper::client.get self.resource_url%attributes
        new_from_response(response)
      end

      def create(attributes)
        response = Droppper::client.post self.collection_url, attributes
        new_from_response(response)
      end

      def destroy(id_or_attributes)
        attributes = id_or_attributes.is_a?(Hash) ? id_or_attributes : {id: id_or_attributes}
        response = Droppper::client.delete self.resource_url%attributes
      end

      def update(id_or_attributes, new_attributes)
        attributes = id_or_attributes.is_a?(Hash) ? id_or_attributes : {id: id_or_attributes}
        Droppper::client.put self.resource_url%attributes, new_attributes
      end

      def new_from_response(response)
        resource = new
        resource.set_attributes_from_response response
        resource
      end
    end

    attr_accessor :attributes, :resource_url

    def initialize(attributes={})
      self.attributes = attributes
    end

    def update(attributes)
      response = self.class.update symbolized_attributes, attributes
      set_attributes_from_response response
    end

    def destroy
      self.class.destroy symbolized_attributes
    end

    def refresh
      response = Droppper::client.get resource_url
      set_attributes_from_response response
    end

    def attributes=(attributes)
      @attributes = attributes
      attributes.each do |k,v|
        send :"#{k}=", v if respond_to?(:"#{k}=")
      end
    end

    def set_attributes_from_response(response)
      response        = JSON.parse(response)
      new_attributes  = response[self.class.resource_name]
      self.attributes = new_attributes if new_attributes
    end

    def resource_url
      @resource_url ||= self.class.resource_url%symbolized_attributes
    end

    protected
      def symbolized_attributes
        h = {}
        self.attributes.each do |k,v|
          h[k.to_sym] = v
        end
        h
      end
  end
end
