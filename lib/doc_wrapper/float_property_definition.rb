module DocWrapper
  class FloatPropertyDefinition < InnerHtmlPropertyDefinition
    def transform (result)
      if block
        result = block.call(result)
      else
        result = result.blank? ? nil : (options[:parser] ? options[:parser].call(result) : result.to_f)
      end
      result
    end
  end
end
