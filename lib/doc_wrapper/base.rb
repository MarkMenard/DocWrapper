module DocWrapper
  module Base
    def initialize (*args)
      @documents = args.flatten
    end
  end
end
