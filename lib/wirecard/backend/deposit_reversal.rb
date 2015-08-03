module Wirecard
  module Backend
    class DepositReversal < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_number, :payment_number]
      end
    end
  end
end