module DocWrapper
  module ClassMethods

    # Create a typed property definition for a document wrapper. 
    # The property_name must be a symbol.
    def property (property_name, type, selector, options = {}, &block)
      raise "Unhandled property type: #{type.to_s}" if ![:string, :date, :time, :boolean, :raw].include?(type)
      add_property_definition(property_name,  build_property_definition(property_name, type, selector, initialize_options(options), block))
    end

    def multi_property (property_name, selectors, options = {}, &block)
      raise "Multi properties require a block" if block.nil?
      add_property_definition(property_name, MultiPropertyDefinition.new(property_name, selectors, initialize_options(options), block))
    end

    def has_many (property_name, selector, klass, options = {})
      options = initialize_options(options)
      define_method property_name do
        get_has_many( property_name, selector, klass, options)
      end
    end

    def has_one (property_name, selector, klass, options = {})
      options = initialize_options(options)
      define_method(property_name) do
        get_has_one(property_name, selector, klass, options)
      end
    end
    
    def namespaces (namespaces)
      @namespaces = namespaces
      # define_method(:namespaces) do
      #   namespaces
      # end
    end
    
    ##################
    # Helper Methods #
    ##################

    def add_property_definition (property_name, wrapper)
      add_property_name(property_name)
      add_property_wrapper(property_name, wrapper)
      add_property_accessor(property_name)
    end

    # Add a property name to the singleton property_names attribute.
    def add_property_name (property_name)
      # Add the property name to the property_names collection.
      self.property_names << property_name
    end

    # Add a property wrapper to the property_definitions Hash.
    def add_property_wrapper (property_name, wrapper)
      self.property_definitions[property_name] = wrapper
    end

    def add_property_accessor (property_name)
      class_eval <<-END
        def #{property_name.to_s}
          property_definitions[:#{property_name.to_s}].property(documents)
        end
      END
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

    
    def build_property_definition (property_name, type, selector, options, block)
      DocWrapper.const_get("#{camelize(type.to_s)}PropertyDefinition").new(property_name, type, selector, initialize_options(options), block)
    end

    def camelize (string)
      string.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
    
  end
end