module Ai
  module Providers
    class Base
      def stream(question)
        raise NotImplementedError, "#{self.class} must implement the #stream method"
      end
    end
  end
end
