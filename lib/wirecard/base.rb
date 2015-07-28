module Wirecard
  class Base
    
    attr_reader :request
    
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
    
    def implicit_fingerprint_order
      nil
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