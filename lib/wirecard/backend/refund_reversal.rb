module Wirecard
  module Backend
    class RefundReversal < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_number, :credit_number]
      end
    end
  end
end