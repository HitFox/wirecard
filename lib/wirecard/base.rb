module Wirecard
  class Base
    
    attr_reader :request
    
    attr_accessor :response
    
    def defaults
      @defaults ||= {
        customer_id: Wirecard.config.customer_id,
        shop_id: Wirecard.config.shop_id
      }
    end
    
    def initialize(params = {})
      @request = Wirecard::Request.new(
        params: defaults.merge(params),
        implicit_fingerprint_order: implicit_fingerprint_order,
        uri: uri
      )
    end
    
    def post
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      self.response = Wirecard::Response.new(http.request(request.to_post)).to_hash
    end
    
    alias_method :save, :post
    
    def method_missing(method_name, *args, &block)
      if response && (response.key?(method_name.to_sym) || response.key?(method_name))
        response[method_name.to_sym] || response[method_name]
      else
        super
      end
    end
    
    def respond_to_missing?(method_name, include_private = false)
      response && (response.key?(method_name.to_sym) || response.key?(method_name)) || super
    end
    
    def implicit_fingerprint_order
      nil
    end
    
    def self.create(attributes = {})
      object = new(attributes)
      object.save
      object
    end
    
    private
    
    def uri
      @uri ||= URI.parse(url)
    end
    
    def url
      raise NotImplementedError, 'A URL must be given to make a call'
    end
    
  end
end