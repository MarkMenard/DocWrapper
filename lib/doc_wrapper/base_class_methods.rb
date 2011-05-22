module DocWrapper
  module ClassMethods

    # Create a typed property definition for a document wrapper. 
    # The property_name must be a symbol.
    def property (property_name, type, selector, options = {}, &block)
      raise "Unhandled property type: #{type.to_s}" if ![:string, :date, :time, :boolean, :raw].include?(type)
      add_property_definition(property_name,  build_property_definition(property_name, type, selector, initialize_options(options), block))
    end

    def multi_property (property_name, selectors, options = {}, &block)
      raise "Multi-properties require a block" if block.nil?
      add_property_definition(property_name, MultiPropertyDefinition.new(property_name, selectors, initialize_options(options), block))
    end

    def has_many (property_name, selector, klass, options = {})
      wrapper = HasManyPropertyDefinition.new(property_name, selector, klass, initialize_options(options))
      define_method property_name do
        wrapper.property(documents)
      end
    end

    def has_one (property_name, selector, klass, options = {})
      wrapper = HasOnePropertyDefinition.new(property_name, selector, klass, initialize_options(options))
      define_method(property_name) do
        wrapper.property(documents)
      end
    end
    
    def namespaces (namespaces)
      @namespaces = namespaces
    end
    
    ##################
    # Helper Methods #
    ##################

    def add_property_definition (property_name, wrapper)
      add_property_name(property_name)
      add_property_accessor(property_name, wrapper)
    end

    # Add a property name to the singleton property_names attribute.
    def add_property_name (property_name)
      self.property_names << property_name
    end

    def add_property_accessor (property_name, wrapper)
      define_method(property_name) do
        wrapper.property(documents)
      end
    end

    def build_property_definition (property_name, type, selector, options, block)
      DocWrapper.const_get("#{camelize(type.to_s)}PropertyDefinition").new(property_name, type, selector, initialize_options(options), block)
    end

    def camelize (string)
      string.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    # Set default options that all properties need.
    def initialize_options (options)
      # Make sure the options have a :document key with a value of 1.
      # This forces all lookups to be for the 0th document in documents if
      # the user did not specify an offset into the array.
      options = { :document => 1 }.merge(options)
      options[:namespaces] = @namespaces if @namespaces
      options
    end
    
  end
end