module Wirecard
  module Fingerprint
    class Sha512 < Base
      def request_fingerprint
        Digest::SHA512.hexdigest(request_fingerprint_string)
      end
    end
  end
end