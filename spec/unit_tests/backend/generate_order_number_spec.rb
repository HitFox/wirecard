require 'spec_helper'

RSpec.describe Wirecard::Backend::GenerateOrderNumber do

  let(:generate_order_number) { Wirecard::Backend::GenerateOrderNumber.new(options) }
  let(:options) { Hash.new }

  include_context 'configuration'

  it { is_expected.to be_a_kind_of(Wirecard::Backend::GenerateOrderNumber) }

  describe '#implicit_fingerprint_order' do
    subject { generate_order_number.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language]) }
  end

  describe '#defaults' do
    subject { generate_order_number.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end

  describe '#url' do
    subject { generate_order_number.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/generateordernumber') }
  end

  describe '#post' do
    subject { generate_order_number.post.response }

    before do
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/generateordernumber").
        with(body: default_backend_request_hash.merge(
          {
            "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5"
          }
        )).
        to_return(
          status: 200,
          body: "status=0&orderNumber=1113051",
          headers: {}
        )
    end

    it { is_expected.to eq({ order_number: '1113051', status: '0' }) }
  end
end