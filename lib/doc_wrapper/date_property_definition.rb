module DocWrapper
  class DatePropertyDefinition < InnerHtmlPropertyDefinition
    def transform (result)
      if block
        result = block.call(result)
      else
        result = result.blank? ? nil : (options[:parser] ? options[:parser].call(result) : Date.parse(result))
      end
      result
    end
  end
end
