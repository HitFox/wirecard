require 'spec_helper'

describe Wirecard do
  
  before do
    Wirecard.configure do |config|
      config.host = 'checkout.wirecard.com'
      config.endpoint = 'https://checkout.wirecard.com/seamless'
      config.customer_id = 'D200001'
      config.shop_id = 'qmore'
      config.secret = 'B8AKTPWBRMNBV455FG6M2DANE99WU2'
      config.success_url = 'http://localhost.success.url'
      config.failure_url = 'http://localhost.failure.url'
      config.cancel_url = 'http://localhost.cancel.url'
      config.service_url = 'http://localhost.service.url'
      config.confirm_url = 'http://localhost.confirm.url'
      config.return_url = 'http://localhost.return.url'
      config.language = 'en'
    end
  end
  
  describe 'data storage' do
    let(:storage_id) { 'd738d62b67ea9719f80530e5097beada' }

    describe 'init' do
      subject { Wirecard::DataStorage::Init.new(order_ident: '123').post }

<<<<<<< HEAD
      #it { is_expected.to eq({storage_id: storage_id, javascript_url: 'https://checkout.wirecard.com/seamless/dataStorage/js/D200001/qmore/d738d62b67ea9719f80530e5097beada/dataStorage.js' }) }
=======
      it { is_expected.to eq(storage_id: storage_id, javascript_url: 'https://checkout.wirecard.com/seamless/dataStorage/js/D200001/qmore/d738d62b67ea9719f80530e5097beada/dataStorage.js') }
>>>>>>> b6ae57f141604cf7659dbae0e67141c8cba2bcf4
    end

    describe 'read' do
      subject { Wirecard::DataStorage::Read.new(storage_id: storage_id).post }

      #it { is_expected.to eq({storage_id: storage_id, payment_informations: '0' }) }
    end
  end
  
  describe 'payment process' do
    let(:params) { {
      payment_type: 'CCARD',
      amount: '1000',
      consumer_ip_address: '127.0.0.1',
      consumer_user_agent: 'some agent',
      currency: 'EUR',
      language: 'de',
      order_description: 'sdfdg'
    } }
    
    describe 'init' do
      subject { Wirecard::PaymentProcess::Init.new(params).post }

      #it { expect(subject.keys).to include(:redirect_url) }
    end
    
    describe 'callback' do
      subject { Wirecard::Callback.new(response_params).to_hash }
      
      let(:response_params) do 
        {
          "amount" => "1000",
          "currency" => "EUR", 
          "paymentType" => "CCARD", 
          "financialInstitution" => "Visa", 
          "language" => "de", 
          "orderNumber" => "5028575", 
          "paymentState" => "SUCCESS", 
          "authenticated" => "No", 
          "anonymousPan" => "0004", 
          "expiry" => "03/2018", 
          "cardholder" => "sdg", 
          "maskedPan" => "940000******0004", 
          "gatewayReferenceNumber" => "DGW_5028575_RN", 
          "gatewayContractNumber" => "DemoContractNumber123", 
          "avsResponseCode" => "X", 
          "avsResponseMessage" => "Demo AVS ResultMessage", 
          "avsProviderResultCode" => "X", 
          "avsProviderResultMessage" => "Demo AVS ProviderResultMessage", 
          "responseFingerprintOrder" => "amount,currency,paymentType,financialInstitution,language,orderNumber,paymentState,authenticated,anonymousPan,expiry,cardholder,maskedPan,gatewayReferenceNumber,gatewayContractNumber,avsResponseCode,avsResponseMessage,avsProviderResultCode,avsProviderResultMessage,secret,responseFingerprintOrder", 
          "responseFingerprint" => response_fingerprint
        }
      end
      
      context 'when response fingerprint is valid' do
        let(:response_fingerprint) { "42c937f7712b69210839c8d149bb17a352e04761eb08d67d28b2319b4a254c923b55cd6270c5d03f32cc9613dc53924c52e7a0dd7ad2139a5334a15cb4763e97" }
        
        context 'when response contains only fingerprinted params' do
          let(:parsed_response_params) do
            {
              amount: "1000",
              currency: "EUR", 
              payment_type: "CCARD", 
              financial_institution: "Visa", 
              language: "de", 
              order_number: "5028575", 
              payment_state: "SUCCESS", 
              authenticated: "No", 
              anonymous_pan: "0004", 
              expiry: "03/2018", 
              cardholder: "sdg", 
              masked_pan: "940000******0004", 
              gateway_reference_number: "DGW_5028575_RN", 
              gateway_contract_number: "DemoContractNumber123", 
              avs_response_code: "X", 
              avs_response_message: "Demo AVS ResultMessage", 
              avs_provider_result_code: "X", 
              avs_provider_result_message: "Demo AVS ProviderResultMessage", 
              response_fingerprint_order: "amount,currency,paymentType,financialInstitution,language,orderNumber,paymentState,authenticated,anonymousPan,expiry,cardholder,maskedPan,gatewayReferenceNumber,gatewayContractNumber,avsResponseCode,avsResponseMessage,avsProviderResultCode,avsProviderResultMessage,secret,responseFingerprintOrder", 
              response_fingerprint: response_fingerprint
            } 
          end
          
          #it { is_expected.to eq(parsed_response_params) }
        end
        
        context 'when response contains unfingerprinted params' do
          subject { Wirecard::Callback.new(response_params.merge(other_params)).to_hash }
          let(:other_params) { {
            "parameter_key" => "parameter_value"
          } }
          
          #it { is_expected.to raise_error(ArgumentError) } TODO: get this to work...
        end
      end
      
      context 'when response fingerprint is invalid' do
        let(:response_fingerprint) { "invalid fingerprint" }
        
        #it { is_expected.to be nil }
      end
      
    end
  end
end