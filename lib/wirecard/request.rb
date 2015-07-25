module Wirecard
  class Request
    attr_accessor :params, :fingerprint_order, :uri
    
    def initialize(parameters, fingerprint_order, uri)
      self.params = parameters
      self.fingerprint_order = fingerprint_order
      self.uri = uri
    end
    
    def to_post
      post_request = Net::HTTP::Post.new(uri.request_uri)
      
      post_request.set_form_data(to_params)
      
      post_request["Host"] = Wirecard::Base.config[:host]
      post_request["User-Agent"] = Wirecard::Base.user_agent
      post_request["Content-Type"] = 'application/x-www-form-urlencoded'
      post_request["Content-Length"] = post_request.body.bytesize.to_s
      post_request["Connection"] = 'close'
      
      post_request
    end
    
    ### ------------------------------------------ ###
    ### ---------------- Helpers ----------------- ###
    ### ------------------------------------------ ###
    
    private
    
    def to_params
      @wirecard_parameters = Hash[params.keys.map{ |key| [camelize(key), params[key]] }]
      
      set_fingerprint_order! unless fingerprint_order
      set_fingerprint!
      
      @wirecard_parameters
    end
    
    def set_fingerprint_order!
      fingerprint_order_string = @wirecard_parameters.keys.select do |key|
        @wirecard_parameters[key] != nil 
      end.compact.join(',').concat(',requestFingerprintOrder,secret')
      
      @wirecard_parameters.merge!({ 'requestFingerprintOrder' => fingerprint_order_string})
    end
    
    def set_fingerprint!
      fingerprint_string = if fingerprint_order
        fingerprint_order.map{ |key| @wirecard_parameters[camelize(key)] }.compact.join
      else
        @wirecard_parameters.values.compact.join
      end.concat(Wirecard::Base.config[:secret])
      
      fingerprint = Digest::SHA512.hexdigest(fingerprint_string)
      
      @wirecard_parameters.merge!({ 'requestFingerprint' => fingerprint})
    end
    
    def camelize(key)
      key.to_s.gsub(/_(.)/) { |e| $1.upcase }
    end
  end
end