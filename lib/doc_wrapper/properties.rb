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
        result[property] = send(property)
      end
      result
    end

  end
end