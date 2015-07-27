require 'spec_helper'

describe Wirecard do
  
  before do
    Wirecard::Base.config = {
      host: 'checkout.wirecard.com',
      endpoint: 'https://checkout.wirecard.com/seamless',
      customer_id: 'D200001',
      shop_id: 'qmore',
      secret: 'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      success_url: 'http://localhost.success.url',
      failure_url: 'http://localhost.failure.url',
      cancel_url: 'http://localhost.cancel.url',
      service_url: 'http://localhost.service.url',
      confirm_url: 'http://localhost.confirm.url'
    }
  end
  
  describe 'data storage' do
    let(:storage_id) { 'd738d62b67ea9719f80530e5097beada' }

    describe 'init' do
      subject { Wirecard::DataStorage::Init.new(order_ident: '123').post }

      it { is_expected.to eq({storage_id: storage_id, javascript_url: 'https://checkout.wirecard.com/seamless/dataStorage/js/D200001/qmore/d738d62b67ea9719f80530e5097beada/dataStorage.js' }) }
    end

    describe 'read' do
      subject { Wirecard::DataStorage::Read.new(storage_id: storage_id).post }

      it { is_expected.to eq({storage_id: storage_id, payment_informations: '0' }) }
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

      it { expect(subject.keys).to include(:redirect_url) }
    end
    
    describe 'callback' do
      subject { Wirecard::Callback.new(response_from_wirecard).to_hash }
      
      let(:response_from_wirecard){ {
        "amount"=>"1000",
        "currency"=>"EUR", 
        "paymentType"=>"CCARD", 
        "financialInstitution"=>"Visa", 
        "language"=>"de", 
        "orderNumber"=>"5028575", 
        "paymentState"=>"SUCCESS", 
        "authenticated"=>"No", 
        "anonymousPan"=>"0004", 
        "expiry"=>"03/2018", 
        "cardholder"=>"sdg", 
        "maskedPan"=>"940000******0004", 
        "gatewayReferenceNumber"=>"DGW_5028575_RN", 
        "gatewayContractNumber"=>"DemoContractNumber123", 
        "avsResponseCode"=>"X", 
        "avsResponseMessage"=>"Demo AVS ResultMessage", 
        "avsProviderResultCode"=>"X", 
        "avsProviderResultMessage"=>"Demo AVS ProviderResultMessage", 
        "responseFingerprintOrder"=>"amount,currency,paymentType,financialInstitution,language,orderNumber,paymentState,authenticated,anonymousPan,expiry,cardholder,maskedPan,gatewayReferenceNumber,gatewayContractNumber,avsResponseCode,avsResponseMessage,avsProviderResultCode,avsProviderResultMessage,secret,responseFingerprintOrder", 
        "responseFingerprint"=>"42c937f7712b69210839c8d149bb17a352e04761eb08d67d28b2319b4a254c923b55cd6270c5d03f32cc9613dc53924c52e7a0dd7ad2139a5334a15cb4763e97", 
        "controller"=>"payments", 
        "action"=>"confirm", 
        "locale"=>"de"
      } }
      
      it { is_expected.to eq({asdf: 'sfg'}) }
      
    end
  end
end