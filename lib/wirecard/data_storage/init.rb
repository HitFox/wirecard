module Wirecard
  module DataStorage
    class Init < Base
      def implicit_fingerprint_order
        @implicit_fingerprint_order ||= super + [:order_ident, :return_url, :language, :javascript_script_version, :secret]
      end
      
      def defaults
        super.merge({ return_url: 'http://localhost.url',
          language: 'de',
          javascript_script_version: 'pci3'
          # don't forget to add custom styles for the iFrame
          #post_params['iframeCssUrl'] ActionController::Base.helpers.asset_url('credit_card_form.css')
        })
      end
    end
  end
end