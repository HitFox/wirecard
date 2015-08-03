module Wirecard
  module Backend
    class GenerateOrderNumber < Base
      
      def self.create(attributes = {})
        object = super
        object.order_number.to_i
      end
      
    end
  end
end