module DocWrapper
  class InnerHtmlPropertyDefinition < BasePropertyDefinition
    def property (documents)
      transform(raw_property(documents))
    end
    
    def raw_property (documents)
      if options[:use_attribute]
        get_nodes(documents).first[options[:use_attribute]]
      else
        get_nodes(documents).inner_html.strip
      end
    end
    
    def get_nodes (documents)
      if options[:namespaces]
        documents[@options[:document] - 1].xpath(@selector, options[:namespaces])
      else
        begin
          documents[@options[:document] - 1].search(@selector)
        rescue Nokogiri::CSS::SyntaxError
          documents[@options[:document] - 1].xpath(@selector)
        end
      end
    end
  end
end
