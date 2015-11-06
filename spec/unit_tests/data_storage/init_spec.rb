require 'spec_helper'

RSpec.describe Wirecard::DataStorage::Init do

  let(:init) { Wirecard::DataStorage::Init.new(options) }
  let(:options) { { order_ident: 'order123' } }

  include_context 'configuration'

  it { is_expected.to be_a_kind_of(Wirecard::DataStorage::Init) }

  describe '#implicit_fingerprint_order' do
    subject { init.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :order_ident, :return_url, :language, :javascript_script_version, :secret]) }
  end

  describe '#defaults' do
    subject { init.defaults }

    include_examples 'Wirecard::Base#defaults'
    it { expect(subject[:javascript_script_version]).to eq('pci3') }
    it { expect(subject[:language]).to eq(config[:language]) }
    it { expect(subject[:return_url]).to eq(config[:return_url]) }
  end

  describe '#url' do
    subject { init.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/dataStorage/init') }
  end

  describe '#post' do
    subject { init.post.response }

    context 'when order_ident is given' do
      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/init").
          with(body: default_request_hash.merge(
            {
              "javascriptScriptVersion" => "pci3",
              "language" => config[:language],
              "orderIdent" => "order123",
              "requestFingerprint" => "855b5ac85144d35c4b32d35ddfbdbbd34770cb33b4d5271a1566c3892e43eb2507253e17e840fd6f2ddcc49d49c79580ba96e239bfe5d4df90bf02ea0484e1b2",
              "returnUrl" => "http://localhost.return.url",
            }
          )).
          to_return(
            status: 200,
            body: "storageId=b2737b746627482e0b024097cadb1b41&javascriptUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2FdataStorage%2Fjs%2FD200001%2Fqmore%2Fb2737b746627482e0b024097cadb1b41%2FdataStorage.js",
            headers: {}
          )
      end

      it { is_expected.to eq ({javascript_url: "https://checkout.wirecard.com/seamless/dataStorage/js/D200001/qmore/b2737b746627482e0b024097cadb1b41/dataStorage.js",
                              storage_id: "b2737b746627482e0b024097cadb1b41"}) }
    end

    context 'when order_ident is missing' do
      let(:options) { Hash.new }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/init").
          with(body: default_request_hash.merge(
            {
              "javascriptScriptVersion" => "pci3",
              "language" => config[:language],
              "requestFingerprint" => "6ebcaa502c04de25dbdca74e6eaa44a7cb3cd0adb2b171433099726848ea40cee3adac2f9c89b6102e02bd2a19106a1012fe0fe72f68b75cc7432adf973cdc18",
              "returnUrl" => "http://localhost.return.url",
            }
          )).
          to_return(
            status: 200,
            body: "error.1.errorCode=15300&error.1.message=ORDERIDENT+has+an+invalid+length.&error.1.consumerMessage=ORDERIDENT+has+an+invalid+length.&errors=1",
            headers: {}
          )
      end

      it { is_expected.to eq ({:"error.1.consumer_message" => "ORDERIDENT has an invalid length.",
                               :"error.1.error_code" => "15300",
                               :"error.1.message" => "ORDERIDENT has an invalid length.",
                               errors: "1",}) }
    end
  end
end