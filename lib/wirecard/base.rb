module Wirecard
  class Base
    
    attr_reader :request
    
    def defaults
      @defaults ||= {
        customer_id: Wirecard::Base.config[:customer_id],
        shop_id: Wirecard::Base.config[:shop_id]
      }
    end
    
    def initialize(params = {})
      @request = Wirecard::Request.new({
        params: defaults.merge(params),
        implicit_fingerprint_order: implicit_fingerprint_order,
        uri: uri
      })
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
    
    ### ------------------------------------------ ###
    ### ---------------- Helpers ----------------- ###
    ### ------------------------------------------ ###
    
    private
    
    def uri
      @uri ||= URI.parse(url)
    end
    
    def implicit_fingerprint_order
      nil
    end
    
    def url
      raise NotImplementedError, 'A URL must be given to make a call'
    end
    
  end
end