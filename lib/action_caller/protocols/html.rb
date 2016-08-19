module ActionCaller
  module Protocols
    # Basic HTML Get operation.
    module HTML
      include Protocols::Base

      def get(path, &block)
        get_base(path, &block)
      end
    end
  end
end
