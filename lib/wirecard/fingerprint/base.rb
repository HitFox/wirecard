module Wirecard
  module Fingerprint
    class Base
    
      attr_reader :params, :implicit_fingerprint_order
    
      def initialize(params, implicit_fingerprint_order = nil)
        @params = params
        @implicit_fingerprint_order = implicit_fingerprint_order
      end
      
      def fingerprinted_params
        set_request_fingerprint_order! unless implicit_fingerprint_order
        set_request_fingerprint!
        @params
      end
    
      private
      
      def set_request_fingerprint_order!
        @params.merge!({ 'requestFingerprintOrder' => request_fingerprint_order })
      end
    
      def request_fingerprint_order
        params.keys.select { |key| params[key] != nil }.join(',').concat(',requestFingerprintOrder,secret')
      end
      
      def set_request_fingerprint!
        @params.merge!({ 'requestFingerprint' => fingerprint })
      end
    
      def fingerprint_string
        if implicit_fingerprint_order
          implicit_fingerprint_order << [:secret]
        else
          (params['requestFingerprintOrder'] || params['responseFingerprintOrder']).split(',')
        end.map{ |key| params[key] || Wirecard::Base.config[:secret] }.compact.join
      end
      
      def fingerprint
        raise NotImplementedError, 'Choose a subclass that specifies the method for digest (MD5/SHA512)'
      end
    end
  end
end