module DocWrapper
  class RawPropertyDefinition < BasePropertyDefinition
    def transform (result)
      result = block.call(result) if block
      result
    end
  end
end