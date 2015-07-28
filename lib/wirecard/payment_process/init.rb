module Wirecard
  module PaymentProcess
    class Init < Wirecard::Base
      def url
        @url ||= [Wirecard.config.endpoint, :frontend, :init].join('/')
      end
      
      def defaults
        super.merge(
          language: Wirecard.config.language,
          currency: Wirecard.config.currency,
          success_url: Wirecard.config.success_url,
          failure_url: Wirecard.config.failure_url,
          cancel_url: Wirecard.config.cancel_url,
          service_url: Wirecard.config.service_url,
          confirm_url: Wirecard.config.confirm_url
        )
      end
    end
  end
end