module Wirecard
  module DataStorage
    class Read < Base
      def fingerprint_order
        @fingerprint_order ||= super + [:storage_id]
      end
    end
  end
end

