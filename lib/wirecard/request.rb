module Wirecard
  class Request
    attr_reader :params, :implicit_fingerprint_order, :uri

    def defaults
      @defaults ||= {
        params: nil,
        implicit_fingerprint_order: nil,
        uri: nil
      }
    end

    def initialize(options)
      options = defaults.merge(options)
      raise ArgumentError 'Options must contain params: <parameters hash>' unless options[:params]
      raise ArgumentError 'Options must contain uri: <wirecard API uri>' unless options[:uri]

      @params = params_to_wirecard(options[:params])
      @implicit_fingerprint_order = keys_to_wirecard(options[:implicit_fingerprint_order])
      @uri = options[:uri]
    end

    def to_post
      post = Net::HTTP::Post.new(uri.request_uri)

      post.set_form_data(fingerprinted_params)

      post["Host"] = Wirecard.config.host
      post["User-Agent"] = Wirecard.config.user_agent
      post["Content-Type"] = 'application/x-www-form-urlencoded'
      post["Content-Length"] = post.body.bytesize.to_s
      post["Connection"] = 'close'

      post
    end

    private

    def params_to_wirecard(params)
      Hash[params.keys.reject{ |key| !params[key] }.map{ |key| [camelize(key), params[key]] }]
    end

    def keys_to_wirecard(keys)
      keys.map{ |key| camelize(key) } if keys
    end

    def camelize(key)
      key.to_s.gsub(/_(.)/) { |e| $1.upcase }
    end

    def fingerprinted_params
      @fingerprinted_params ||= Wirecard::Fingerprint::Sha512.new(params, implicit_fingerprint_order).fingerprinted_params
    end
  end
end