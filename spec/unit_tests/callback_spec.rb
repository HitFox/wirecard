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

  describe 'length extension attack' do
    let(:callback) { Wirecard::Callback.new(forged_params) }
    subject { callback.fingerprint_valid? }

    # these parameters have been created based on existing parameters and using length extension to fake a new fingerprint
    # the callback class should scan for inidcators of such an attack and should classify fingerprints as invalid in these cases
    let(:forged_params) { {
      "part1" => CGI.parse("D200001qmoreenUSDhttp%3A%2F%2Flocalhost.success.urlhttp%3A%2F%2Flocalhost.failure.urlhttp%3A%2F%2Flocalhost.cancel.urlhttp%3A%2F%2Flocalhost.service.urlhttp%3A%2F%2Flocalhost.confirm.urlCCARDb2737b746627482e0b024097cadb1b411000description127.0.0.1agent").first.first,
      "part2" => CGI.parse("customerId%2CshopId%2Clanguage%2Ccurrency%2CsuccessUrl%2CfailureUrl%2CcancelUrl%2CserviceUrl%2CconfirmUrl%2CpaymentType%2CstorageId%2Camount%2CorderDescription%2CconsumerIpAddress%2CconsumerUserAgent%2Csecret%2CrequestFingerprintOrder%80%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%0E0").first.first,
      "customerId" => "D200001",
      "paymentType" => "CCARD",
      "storageId" => "b2737b746627482e0b024097cadb1b41",
      "amount" => "1000",
      "currency" => "USD",
      "orderDescription" => "description",
      "consumerIpAddress" => "127.0.0.1",
      "consumerUserAgent" => "agent",
      "language" => "en",
      "successUrl" => CGI.parse("http%3A%2F%2Flocalhost.url%2Fsuccess").first.first,
      "failureUrl" => CGI.parse("http%3A%2F%2Flocalhost.url%2Ffailure").first.first,
      "cancelUrl" => CGI.parse("http%3A%2F%2Flocalhost.url%2Fcancel").first.first,
      "serviceUrl" => CGI.parse("http%3A%2F%2Flocalhost.url%2Fservice").first.first,
      "confirmUrl" => CGI.parse("http%3A%2F%2Flocalhost.url%2Fconfirm").first.first,
      "orderIdent" => "order123",
      "responseFingerprintOrder" => CGI.parse("part1%2Csecret%2Cpart2%2CcustomerId%2CpaymentType%2CstorageId%2Camount%2Ccurrency%2CorderDescription%2CconsumerIpAddress%2CconsumerUserAgent%2Clanguage%2CsuccessUrl%2CfailureUrl%2CcancelUrl%2CserviceUrl%2CconfirmUrl%2CorderIdent%2CresponseFingerprintOrder").first.first,
      "responseFingerprint" => "7528cfc8fb0b0ed009d634af624939ab60e268d39b848de72c85380719eb36e8903c7ffeb2646427da5482900c7b6df13aac726ee9fc0e475bae691d30efe9d9"
      } }

    it { is_expected.to be false }
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