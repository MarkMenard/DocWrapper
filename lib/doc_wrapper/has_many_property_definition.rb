class HasManyPropertyDefinition
  
  attr_accessor :property_name, :selector, :klass, :options, :nodes
  
  def initialize (property_name, selector, klass, options)
    @property_name = property_name
    @selector = selector
    @klass = klass
    @options = options
  end
  
  def property (documents)
    self.nodes = documents.collect do |doc| 
      if options[:namespaces]
        result = doc.search(selector, options[:namespaces]) 
      else
        result = doc.search(selector) 
      end
      result.blank? ? nil : result 
    end.flatten.compact
    
    nodes[start_row..end_row].collect { |node| klass.new(node) }
  end
  
  def start_row
    options[:start_row] ? options[:start_row] : 0
  end
  
  def end_row
    options[:end_row] ? options[:end_row] : nodes.size - 1
  end
  
end