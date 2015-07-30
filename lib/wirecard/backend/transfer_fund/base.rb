module Wirecard
  module Backend
    module TransferFund
      class Base < Wirecard::Backend::Base
        def url
          @url ||= [Wirecard.config.endpoint, :backend, :transferfund].join('/')
        end
        
        def implicit_fingerprint_order
          @implicit_fingerprint_order ||= super + [:order_number, :credit_number, :order_description, :amount, :currency, :order_reference, :customer_statement, :fund_transfer_type]
        end
      end
    end
  end
end