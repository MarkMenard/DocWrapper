class HasOnePropertyDefinition
  
  attr_accessor :property_name, :selector, :klass, :options
  
  def initialize (property_name, selector, klass, options)
    @property_name = property_name
    @selector = selector
    @klass = klass
    @options = options
  end
  
  def property (documents)
    nodes = documents.collect { |doc| result = doc.search(selector) ; result.blank? ? nil : result }.flatten.compact
    klass.new(nodes)
  end
  
end