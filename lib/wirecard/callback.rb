module Wirecard
  class Callback
    
    attr_reader :params, :response_fingerprint
    
    def initialize(params)
      raise ArgumentError, 'fingerprint order and fingerprint must both be set' unless params['responseFingerprintOrder'] && params['responseFingerprint']
      
      @params = params
      @response_fingerprint = params['responseFingerprint']
    end
    
    def to_hash
      fingerprint_valid? ? params_to_ruby : nil
    end
    
    def computed_fingerprint
      @computed_fingerprint ||= Wirecard::Fingerprint::Sha512.new(params).fingerprint
    end
    
    def fingerprint_valid?
      computed_fingerprint == response_fingerprint
    end
    
    private
    
    def underscore(s)
      s.gsub(/([A-Z])/) { |e| '_' + $1.downcase }
    end
    
    def params_to_ruby
      @ruby_params ||= Hash[params.map{ |key, value| [underscore(key).to_sym, value] }]
    end
    
  end
end
