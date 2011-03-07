module DocWrapper
  class MultiPropertyDefinition
    attr_accessor :property_name, :selectors, :options, :block

    def initialize (property_name, selectors, options, block)
      @property_name = property_name
      @selectors = selectors
      @options = options
      @block = block
    end

    def property (documents)
      results = []
      selectors.each do |selector|
        nodes = documents[@options[:document] - 1].search(selector)
        if nodes.respond_to? :inner_html
          nodes.each do |node|
            results << node.inner_html.strip
          end
        else
          results << nodes.inner_html.strip
        end
      end
      transform(results.flatten)
    end

    def transform (results)
      return nil if results.size == 0
      result = block.call(results)
    end
  end
end