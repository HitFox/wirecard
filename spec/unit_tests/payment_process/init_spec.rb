require 'spec_helper'

RSpec.describe Wirecard::PaymentProcess::Init do

  let(:init) { Wirecard::PaymentProcess::Init.new(options) }
  let(:options) { Hash.new.merge(payment_type_data).merge(payment_data).merge(consumer_data) }
  let(:payment_type_data) { { payment_type: 'CCARD', storage_id: 'b2737b746627482e0b024097cadb1b41' } }
  let(:payment_data) { { amount: '1000', currency: 'USD', order_description: 'some description' } }
  let(:consumer_data) { { consumer_ip_address: '127.0.0.1', consumer_user_agent: 'some agent', language: 'en'} }

  before do
    ### stub request to generate order number for this payment process: will return 1113051
    stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
      with(body: default_request_hash.merge(
        {
          "language"=>"en",
          "password"=>"jcv45z",
          "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5",
          "shopId"=>"qmore"
        }
      )).
      to_return(
        status: 200,
        body: "status=0&orderNumber=1113051",
        headers: {}
      )
  end

  include_context 'configuration'
  include_context 'stub requests'

  let(:default_payment_process_request_hash) do
    default_request_hash.merge(
      {
        "amount"=>"1000",
        "currency"=>"USD",
        "orderDescription"=>"some description",
        "consumerIpAddress"=>"127.0.0.1",
        "consumerUserAgent"=>"some agent",
        "language"=>"en",
        "failureUrl"=>"http://localhost.failure.url",
        "orderNumber"=>"1113051",
        "cancelUrl"=>"http://localhost.cancel.url",
        "confirmUrl"=>"http://localhost.confirm.url",
        "serviceUrl"=>"http://localhost.service.url",
        "successUrl"=>"http://localhost.success.url"
      }
    )
  end

  it { is_expected.to be_a_kind_of(Wirecard::PaymentProcess::Init) }

  describe '#implicit_fingerprint_order' do
    subject { init.implicit_fingerprint_order }

    it { is_expected.to be nil }
  end

  describe '#defaults' do
    subject { init.defaults }

    include_examples 'Wirecard::Base#defaults'
    it { expect(subject[:order_number]).to eq(1113051) }
    it { expect(subject[:language]).to eq(config[:language]) }
    it { expect(subject[:currency]).to eq(config[:currency]) }
    it { expect(subject[:success_url]).to eq(config[:success_url]) }
    it { expect(subject[:failure_url]).to eq(config[:failure_url]) }
    it { expect(subject[:cancel_url]).to eq(config[:cancel_url]) }
    it { expect(subject[:service_url]).to eq(config[:service_url]) }
    it { expect(subject[:confirm_url]).to eq(config[:confirm_url]) }
  end

  describe '#url' do
    subject { init.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/frontend/init') }
  end

  describe '#post' do
    subject { init.post.response }

    context 'when credit card payment' do
      let(:payment_type_data) { { payment_type: 'CCARD', storage_id: 'b2737b746627482e0b024097cadb1b41' } }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
          with(body: default_payment_process_request_hash.merge(
            {
              "paymentType"=>"CCARD",
              "storageId"=>"b2737b746627482e0b024097cadb1b41",
              "requestFingerprint"=>"db79d074ea5a1572425d54877097cde8fd72ae32a7587cc5d77103e9ff0d807ee64f7b4010ad06b3a2e13be605f87ea35895cf541a9790d15e46f1008e8e638d",
              "requestFingerprintOrder"=>"customerId,shopId,orderNumber,language,currency,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,paymentType,storageId,amount,orderDescription,consumerIpAddress,consumerUserAgent,requestFingerprintOrder,secret",
            }
          )).
          to_return(
            status: 200,
            body: "redirectUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2Ffrontend%2FD200001qmore_DESKTOP%2Fselect.php%3FSID%3Dttkbc64otkqk067oca49ft0cr5",
            headers: {}
          )
      end

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=ttkbc64otkqk067oca49ft0cr5" } ) }
    end

    context 'when Sofortüberweisung payment' do
      let(:payment_type_data) { { payment_type: 'SOFORTUEBERWEISUNG' } }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
          with(body: default_payment_process_request_hash.merge(
            {
              "paymentType"=>"SOFORTUEBERWEISUNG",
              "requestFingerprint"=>"4c03194780d2383617ac360af521b9cfb2a201cec496e7f205b1ffc276b7de586fb354ad39546d9561ad99f8df5edf0bc3cf8ebeed490212da289e1d90c1db4b",
              "requestFingerprintOrder"=>"customerId,shopId,orderNumber,language,currency,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,paymentType,amount,orderDescription,consumerIpAddress,consumerUserAgent,requestFingerprintOrder,secret",
            }
          )).
          to_return(
            status: 200,
            body: "redirectUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2Ffrontend%2FD200001qmore_DESKTOP%2Fselect.php%3FSID%3Dckovh2titpm7kagm48e532ifc6",
            headers: {}
          )
      end

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=ckovh2titpm7kagm48e532ifc6" } ) }
    end

    context 'when SEPA payment' do
      let(:payment_type_data) { { payment_type: 'SEPA-DD' } }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
          with(body: default_payment_process_request_hash.merge(
            {
              "paymentType"=>"SEPA-DD",
              "requestFingerprint"=>"b1fbcb93f59b5e1a90d1525a5eb889bea2a6fa5ebac5b1956999d09a6cc0707ca0bb02dc4cb13c4ecda8533175f5be9275680328a00f70976b06d0ef410699f9",
              "requestFingerprintOrder"=>"customerId,shopId,orderNumber,language,currency,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,paymentType,amount,orderDescription,consumerIpAddress,consumerUserAgent,requestFingerprintOrder,secret",
            }
          )).
          to_return(
            status: 200,
            body: "redirectUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2Ffrontend%2FD200001qmore_DESKTOP%2Fselect.php%3FSID%3Dj5bk04off945jg6qv25imb1en4",
            headers: {}
          )
      end

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=j5bk04off945jg6qv25imb1en4" } ) }
    end

    context 'when PayPal payment' do
      let(:payment_type_data) { { payment_type: 'PAYPAL' } }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
          with(body: default_payment_process_request_hash.merge(
            {
              "paymentType"=>"PAYPAL",
              "requestFingerprint"=>"96ba6c823b9d4a4f18cdd4b6eff062b951a91e70df0a61805a821dcd4640a84ff582ed79810887d0e96953d7d1ef7fd08844d9b9780e2ae8af0653a9a77c12b6",
              "requestFingerprintOrder"=>"customerId,shopId,orderNumber,language,currency,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,paymentType,amount,orderDescription,consumerIpAddress,consumerUserAgent,requestFingerprintOrder,secret",
            }
          )).
          to_return(
            status: 200,
            body: "redirectUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2Ffrontend%2FD200001qmore_DESKTOP%2Fselect.php%3FSID%3D1ccoq6lf3euji7dk018sulomg6",
            headers: {}
          )
      end

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=1ccoq6lf3euji7dk018sulomg6" } ) }
    end

    context 'when options are invalid' do
      let(:options) { Hash.new }

      before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
            with(body: default_payment_process_request_hash.reject{|key,value| ['amount', 'currency', 'orderDescription', 'consumerIpAddress', 'consumerUserAgent'].include?(key) }.merge(
              {
                "requestFingerprint"=>"e830fb6a2fcd7ae6f00d3163fb8b9aef5bf2bbfc2ce0b203e51cd3e66925f266e1babc7715f7c93047b78bbf0b4bd0787b20589bdbab03efdeb00f011ddc5c30",
                "requestFingerprintOrder"=>"customerId,shopId,orderNumber,language,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,requestFingerprintOrder,secret",
              }
            )).
            to_return(
              status: 200,
              body: "error.1.message=PAYMENTTYPE+is+missing.&error.1.consumerMessage=PAYMENTTYPE+is+missing.&error.1.errorCode=11051&error.2.message=Currency+is+missing.&error.2.consumerMessage=Currency+is+missing.&error.2.errorCode=11019&error.3.message=Order+description+is+missing.&error.3.consumerMessage=Order+description+is+missing.&error.3.errorCode=11020&error.4.message=Amount+is+missing.&error.4.consumerMessage=Amount+is+missing.&error.4.errorCode=11017&error.5.message=IP-Address+is+missing.&error.5.consumerMessage=IP-Address+is+missing.&error.5.errorCode=11146&error.6.message=USER_AGENT+is+missing.&error.6.consumerMessage=USER_AGENT+is+missing.&error.6.errorCode=11130&errors=6",
              headers: {}
            )
      end

      it { is_expected.to eq ({
         :"error.1.consumer_message" => "PAYMENTTYPE is missing.",
         :"error.1.error_code" => "11051",
         :"error.1.message" => "PAYMENTTYPE is missing.",
         :"error.2.consumer_message" => "Currency is missing.",
         :"error.2.error_code" => "11019",
         :"error.2.message" => "Currency is missing.",
         :"error.3.consumer_message" => "Order description is missing.",
         :"error.3.error_code" => "11020",
         :"error.3.message" => "Order description is missing.",
         :"error.4.consumer_message" => "Amount is missing.",
         :"error.4.error_code" => "11017",
         :"error.4.message" => "Amount is missing.",
         :"error.5.consumer_message" => "IP-Address is missing.",
         :"error.5.error_code" => "11146",
         :"error.5.message" => "IP-Address is missing.",
         :"error.6.consumer_message" => "USER_AGENT is missing.",
         :"error.6.error_code" => "11130",
         :"error.6.message" => "USER_AGENT is missing.",
         errors: "6"}) }
     end
  end
end