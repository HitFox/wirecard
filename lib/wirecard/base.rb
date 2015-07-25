module Wirecard
  class Base
    
    attr_accessor :request
    
    def params
      request.params
    end
    
    def initialize(options = {})
      self.request = Wirecard::Request.new(defaults.merge(options), fingerprint_order, uri)
    end
    
    def defaults
      @defaults ||= {
        customer_id: Wirecard::Base.config[:customer_id],
        shop_id: Wirecard::Base.config[:shop_id]
      }
    end
    
    def fingerprint_order
      nil
    end
    
    def uri
      @uri ||= URI.parse(url)
    end
    
    def url
      raise NotImplementedError, 'A URL must be given to make a call'
    end
    
    ### ------------------------------------------ ###
    ### ------------ Configuration --------------- ###
    ### ------------------------------------------ ###
    
    def self.config=(options)
      @@config = options
    end
    
    def self.config
      @@config
    end
    
    def self.user_agent
      '### User Agent ###'
    end
    
    ### ------------------------------------------ ###
    ### -------------- API request --------------- ###
    ### ------------------------------------------ ###
    
    def post
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      Wirecard::Response.new(http.request(request.to_post)).to_hash
    end
  end
end