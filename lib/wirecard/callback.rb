module Wirecard
  class Callback
    
    attr_reader :params
    
    def initialize(params)
      @params = params
    end
    
    def to_hash
      fingerprint_valid? ? params_to_ruby : {}
    end
    
    def fingerprint_valid?
      !suspicious_values? && !!response_fingerprint && !!response_fingerprint_order && !unfingerprinted_params? && (computed_fingerprint == response_fingerprint)
    end
    
    private
    
    def response_fingerprint
      @response_fingerprint ||= params['responseFingerprint']
    end
    
    def response_fingerprint_order
      @response_fingerprint_order ||= params['responseFingerprintOrder']
    end
    
    def fingerprinted_params
      @fingerprinted_params ||= response_fingerprint_order.split(',')
    end
    
    def unfingerprinted_params
      @unfingerprinted_params ||= params.keys - fingerprinted_params - ['responseFingerprint']
    end
    
    def unfingerprinted_params?
      unfingerprinted_params.size > 0
    end
    
    # scans all parameter values for bit sequence "10000000" (\x80), which indicates a length extension attack on the fingerprint
    def suspicious_values?
      params.values.select{ |value| value.bytes.include?(128) }.compact.any?
    end
    
    def underscore(s)
      s.gsub(/([A-Z])/) { |e| '_' + $1.downcase }
    end
    
    def params_to_ruby
      @ruby_params ||= Hash[params.map{ |key, value| [underscore(key).to_sym, value] }]
    end
    
    def computed_fingerprint
      @computed_fingerprint ||= Wirecard::Fingerprint::Sha512.new(params).fingerprint
    end
  end
end
