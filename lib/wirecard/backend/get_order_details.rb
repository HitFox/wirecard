module Wirecard
  module Backend
    class GetOrderDetails < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_number]
      end
    end
  end
end