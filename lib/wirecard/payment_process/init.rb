module Wirecard
  module PaymentProcess
    class Init < Wirecard::Base
      def url
        @url ||= [Wirecard::Base.config[:endpoint], :frontend, :init].join('/')
      end
      
      def defaults
        super.merge({
          language: Wirecard::Base.config[:language],
          currency: Wirecard::Base.config[:currency],
          success_url: Wirecard::Base.config[:success_url],
          failure_url: Wirecard::Base.config[:failure_url],
          cancel_url: Wirecard::Base.config[:cancel_url],
          service_url: Wirecard::Base.config[:service_url],
          confirm_url: Wirecard::Base.config[:confirm_url]
        })
      end
    end
  end
end