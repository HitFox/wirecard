module Wirecard
  module DataStorage
    class Init < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_ident, :return_url, :language, :javascript_script_version, :secret]
      end
      
      def defaults
        super.merge(
          javascript_script_version: 'pci3',
          language: Wirecard.config.language,
          return_url: Wirecard.config.return_url
        )
      end
    end
  end
end