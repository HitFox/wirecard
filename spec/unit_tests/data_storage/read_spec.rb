require 'spec_helper'

RSpec.describe Wirecard::DataStorage::Read do

  let(:read) { Wirecard::DataStorage::Read.new(options) }
  let(:options) { { storage_id: 'b2737b746627482e0b024097cadb1b41' } }

  include_context 'configuration'

  it { is_expected.to be_a_kind_of(Wirecard::DataStorage::Read) }

  describe '#implicit_fingerprint_order' do
    subject { read.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :storage_id, :secret]) }
  end

  describe '#defaults' do
    subject { read.defaults }

    include_examples 'Wirecard::Base#defaults'
  end

  describe '#url' do
    subject { read.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/dataStorage/read') }
  end

  describe '#post' do
    subject { read.post.response }

    #include_context 'stub requests'

    context 'when storage_id is given' do
      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/read").
          with(body: default_request_hash.merge(
            {
              "requestFingerprint"=>"eb6a688db153b6f215c12d98c9cccaf8d60dec0e64bab967e2cae0b868fa30a3edf91ef8a17ee40d3984b0a4742aecf049446fea696740470e45121ccdfe6cbd",
              "storageId"=>"b2737b746627482e0b024097cadb1b41"
            }
          )).
          to_return(
            status: 200,
            body: "storageId=b2737b746627482e0b024097cadb1b41&paymentInformations=0",
            headers: {}
          )
      end

      it { is_expected.to eq ({payment_informations: '0',
                              storage_id: "b2737b746627482e0b024097cadb1b41"}) }
    end

    context 'when storage_id is missing' do
      let(:options) { Hash.new }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/read").
          with(body: default_request_hash.merge(
            {
              "requestFingerprint"=>"7378bce0cab7ef7edb08f178c23146332ecce459409393b4d97e4e0e2da0bf86489f0d1c28a3cb8d549b56879e8b42a42a61a59c184d4f2335a1531b97b5bc27"
            }
          )).
          to_return(
            status: 200,
            body: "error.1.errorCode=11302&error.1.message=STORAGEID+is+missing.&errors=1",
            :headers => {}
          )
      end

      it { is_expected.to eq ({:"error.1.error_code" => "11302",
                              :"error.1.message" => "STORAGEID is missing.",
                              errors: '1'}) }
    end
  end
end