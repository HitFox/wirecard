module Wirecard
  class Configuration
    
    attr_accessor :customer_id
    
    attr_accessor :shop_id
    
    attr_accessor :host
    
    attr_accessor :user_agent
    
    attr_accessor :endpoint
    
    attr_accessor :secret
    
    attr_accessor :language
    
    attr_accessor :currency
    
    attr_accessor :success_url
    
    attr_accessor :failure_url
    
    attr_accessor :cancel_url
    
    attr_accessor :service_url
    
    attr_accessor :confirm_url
    
    attr_accessor :return_url
    
    def initialize
      @user_agent  = '### User Agent ###'
      @endpoint    = 'https://checkout.wirecard.com/seamless'
      @host        = 'checkout.wirecard.com'
      @language    = defined?(I18n) ? I18n.default_locale[0..1] : 'en'
    end
    
  end
end