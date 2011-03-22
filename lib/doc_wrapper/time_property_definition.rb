require 'time'

module DocWrapper
  class TimePropertyDefinition < InnerHtmlPropertyDefinition
    def transform (result)
      if block
        result = block.call(result)
      else
        result = result.blank? ? nil : (options[:parser] ? options[:parser].call(result) : Time.parse(result))
      end
      result
    end
  end
end
