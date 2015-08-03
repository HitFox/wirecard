module Wirecard
  module Backend
    class RecurPayment < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_number, :source_order_number, :auto_deposit, :order_description, :amount, :currency, :order_reference, :customer_statement]
      end
    end
  end
end