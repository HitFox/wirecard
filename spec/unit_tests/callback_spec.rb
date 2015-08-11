require 'spec_helper'

RSpec.describe Wirecard::Callback do
  let(:callback) { Wirecard::Callback.new(response_params.merge(additional_params)) }
  let(:additional_params) { Hash.new }
  
  it { expect(true).to eq(true) }
  
  include_examples 'configuration'
  
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
  let(:response_fingerprint) { "42c937f7712b69210839c8d149bb17a352e04761eb08d67d28b2319b4a254c923b55cd6270c5d03f32cc9613dc53924c52e7a0dd7ad2139a5334a15cb4763e97" }
  
  describe '#to_hash' do
    subject { callback.to_hash }

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

    it { is_expected.to eq(parsed_response_params) }
  end
  
  describe '#fingerprint_valid?' do
    subject { callback.fingerprint_valid? }
    
    context 'when fingerprint is valid' do
      let(:response_fingerprint) { "42c937f7712b69210839c8d149bb17a352e04761eb08d67d28b2319b4a254c923b55cd6270c5d03f32cc9613dc53924c52e7a0dd7ad2139a5334a15cb4763e97" }
      
      it { is_expected.to be true }
      
      context 'when response contains unfingerprinted params' do
        let(:additional_params) { { "parameter_key" => "parameter_value" } }

        it { is_expected.to be false }
      end
    end
    
    context 'when fingerprint is invalid' do
      let(:response_fingerprint) { "invalid fingerprint" }
      
      it { is_expected.to be false }
    end
    
    context 'when response contains no fingerprint' do
      let(:additional_params) { { "responseFingerprint" => nil } }

      it { is_expected.to be false }
    end
    
    context 'when response contains no fingerprint order' do
      let(:additional_params) { { "responseFingerprintOrder" => nil } }

      it { is_expected.to be false }
    end
  end
end