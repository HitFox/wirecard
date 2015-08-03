module Wirecard
  module Backend
    class Deposit < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_number, :amount, :currency]
      end
    end
  end
end