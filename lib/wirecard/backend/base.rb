module Wirecard
  module Backend
    class Base < Wirecard::Base
      def url
        @url ||= [Wirecard.config.endpoint, :backend, self.class.to_s.split('::').last.downcase].join('/')
      end
      
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= [:customer_id, :shop_id, :password, :secret, :language]
      end
      
      def defaults
        super.merge(
          password: Wirecard.config.password,
          language: Wirecard.config.language
        )
      end
    end
  end
end