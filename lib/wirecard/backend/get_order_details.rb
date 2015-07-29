module Wirecard
  module Backend
    class GetOrderDetails < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= [:customer_id, :shop_id, :password, :secret, :language, :order_number]
      end
    end
  end
end