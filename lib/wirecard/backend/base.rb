module Wirecard
  module Backend
    class Base < Wirecard::Base
      def url
        @url ||= [Wirecard.config.endpoint, :backend, self.class.to_s.split('::').last.downcase].join('/')
      end
      
      def defaults
        super.merge(
          password: Wirecard.config.password,
          language: Wirecard.config.language
        )
      end
    end
  end
end