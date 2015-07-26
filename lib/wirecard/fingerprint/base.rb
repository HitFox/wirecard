module Wirecard
  module Fingerprint
    class Base
    
      attr_reader :params, :implicit_fingerprint_order
    
      def initialize(params, implicit_fingerprint_order = nil)
        @params = params
        @implicit_fingerprint_order = implicit_fingerprint_order
      end
    
      def request_fingerprint_order
        params.keys.select { |key| params[key] != nil }.join(',').concat(',requestFingerprintOrder,secret')
      end
    
      private
    
      def request_fingerprint_string
        if implicit_fingerprint_order
          implicit_fingerprint_order.map{ |key| params[key] }.compact.join
        else
          params.values.compact.join
        end.concat(Wirecard::Base.config[:secret])
      end
    end
  end
end