module DocWrapper
  class BooleanPropertyDefinition < InnerHtmlPropertyDefinition
    def transform (result)
      raise "BooleanPropertyDefinition: boolean_test is deprecated please use options[:parser] or a block." if options[:boolean_test]
      if block
        result = block.call(result)
      else
        result = result.blank? ? nil : (options[:parser] ? options[:parser].call(result) : options[:boolean_test].call(result) )
      end
      result
    end
  end
end
