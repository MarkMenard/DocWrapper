module DocWrapper
  class BasePropertyDefinition
    attr_accessor :property_name, :type, :selector, :options, :block

    def initialize (property_name, type, selector, options, block)
      @property_name = property_name
      @type = type
      @selector = selector
      @options = options
      @block = block
    end

    def property (documents)
      if options[:namespaces]
        transform(documents[@options[:document] - 1].xpath(@selector, options[:namespaces] ))
      else
        begin
          transform(documents[@options[:document] - 1].search(@selector))
        rescue Nokogiri::CSS::SyntaxError
          transform(documents[@options[:document] - 1].xpath(@selector))
        end
      end
    end

    def transform (result)
      result
    end
  end
end