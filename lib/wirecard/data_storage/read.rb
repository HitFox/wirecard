module Wirecard
  module DataStorage
    class Read < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:storage_id]
      end
    end
  end
end

