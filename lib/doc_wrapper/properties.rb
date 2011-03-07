module DocWrapper
  module Properties
   
    attr_reader :documents

    def self.included (base)
      base.extend(SattrAccessor)
      base.extend(ClassMethods)
      base.sattr_accessor :property_names
      base.sattr_accessor :property_definitions
      base.property_names = []
      base.property_definitions = {}
    end

    def properties
      result = Hash.new
      property_names.each do |property|
        begin
          result[property] = send(property)
        rescue StandardError => e
          raise e
        end
      end
      result
    end

    def get_has_many (property_name, selector, klass, options)
      nodes = @documents.collect { |doc| result = doc.search(selector) ; result.blank? ? nil : result }.flatten.compact
      start_row = options[:start_row] ? options[:start_row] : 0
      end_row = options[:end_row] ? options[:end_row] : nodes.size - 1
      nodes[start_row..end_row].collect { |node| klass.new(node) }
    end

    def get_has_one (property_name, selector, klass, options)
      nodes = @documents.collect { |doc| result = doc.search(selector) ; result.blank? ? nil : result }.flatten.compact
      klass.new(nodes)
    end
  end
end