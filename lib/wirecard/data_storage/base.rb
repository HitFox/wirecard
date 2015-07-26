module Wirecard
  module DataStorage
    class Base < Wirecard::Base
      def url
        @url ||= [Wirecard::Base.config[:endpoint], :dataStorage, self.class.to_s.split('::').last.downcase].join('/')
      end
      
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= [:customer_id, :shop_id]
      end
    end
  end
end