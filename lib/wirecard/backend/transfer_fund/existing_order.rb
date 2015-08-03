module Wirecard
  module Backend
    module TransferFund
      class ExistingOrder < Base
        def implicit_fingerprint_order
          @implicit_fingerprint_order ||= super + [:source_order_number]
        end
      end
    end
  end
end