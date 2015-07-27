module Wirecard
  module Fingerprint
    class Sha512 < Base
      def fingerprint
        Digest::SHA512.hexdigest(fingerprint_string)
      end
    end
  end
end