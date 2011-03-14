module DocWrapper
  class InnerHtmlPropertyDefinition < BasePropertyDefinition
    def property (documents)
      if options[:namespaces]
        transform(documents[@options[:document] - 1].xpath(@selector, options[:namespaces]).inner_html.strip)
      else
        begin
          transform(documents[@options[:document] - 1].search(@selector).inner_html.strip)
        rescue Nokogiri::CSS::SyntaxError
          transform(documents[@options[:document] - 1].xpath(@selector).inner_html.strip)
        end
      end
    end
  end
end
