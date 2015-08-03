module Wirecard
  module Backend
    class GenerateOrderNumber < Base
      
      def self.create(attributes = {})
        super
        order_number
      end
      
    end
  end
end