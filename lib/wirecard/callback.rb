module Wirecard
  class Callback
    
    attr_reader :params
    
    def initialize(params)
      @params = params
      
      raise NoFingerprintError, 'fingerprint order and fingerprint must both be set' unless response_fingerprint && response_fingerprint_order
      raise UnfingerprintedParamsError, 'parameter hash contain parameters not covered in the fingerprint: ' + unfingerprinted_params.join(',') if unfingerprinted_params.size > 0
      
      truncate_params!
    end
    
    def to_hash
      fingerprint_valid? ? params_to_ruby : nil
    end
    
    def fingerprint_valid?
      computed_fingerprint == response_fingerprint
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
    
    def truncate_params!
      params.keys.each{ |key| params.delete(key) unless fingerprinted_params.include?(key) || key == 'responseFingerprint' }
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
  
  class UnfingerprintedParamsError < StandardError; end
  class NoFingerprintError < StandardError; end
end
