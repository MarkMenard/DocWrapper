require 'date'

module DocWrapper
  class DatePropertyDefinition < InnerHtmlPropertyDefinition
    def transform (result)
      block ? block.call(result) : (result.blank? ? nil : (options[:parser] ? options[:parser].call(result) : Date.parse(result)))
    end
  end
end
