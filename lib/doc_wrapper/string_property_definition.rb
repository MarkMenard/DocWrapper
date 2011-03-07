module DocWrapper
  class StringPropertyDefinition < InnerHtmlPropertyDefinition
    def transform (result)
      result = options[:parser].call(result) if !result.blank? && options[:parser]
      result = block.call(result) if block
      result
    end
  end
end
