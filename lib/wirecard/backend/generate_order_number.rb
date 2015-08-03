module Wirecard
  module Backend
    class GenerateOrderNumber < Base
      
      def self.create(attributes = {})
        object = super
        object.order_number
      end
      
    end
  end
end