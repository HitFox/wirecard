module Wirecard
  class Response
    attr_reader :body
    
    def initialize(http_response)
      @body = http_response.body
    end
    
    def to_hash
      Hash[CGI.parse(body).map{ |param| extract_key_value(param) }]
    end
    
    ### ------------------------------------------ ###
    ### ---------------- Helpers ----------------- ###
    ### ------------------------------------------ ###
    
    private
    
    def underscore(s)
      s.gsub(/([A-Z])/) { |e| '_' + $1.downcase }
    end
    
    def extract_key_value(param)
      [underscore(param[0]).to_sym, param[1].join(',')]
    end
  end
end