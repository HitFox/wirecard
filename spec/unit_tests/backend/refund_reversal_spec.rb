require 'spec_helper'

RSpec.describe Wirecard::Backend::RefundReversal do

  let(:refund_reversal) { Wirecard::Backend::RefundReversal.new(options) }
  let(:options) { Hash.new.merge(order_number).merge(credit_number) }
  let(:order_number) { { order_number: '23473341' } }
  let(:credit_number) { { credit_number: '14949449'} }

  include_context 'configuration'

  it { is_expected.to be_a_kind_of(Wirecard::Backend::RefundReversal) }

  describe '#implicit_fingerprint_order' do
    subject { refund_reversal.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :credit_number]) }
  end

  describe '#defaults' do
    subject { refund_reversal.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end

  describe '#url' do
    subject { refund_reversal.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/refundreversal') }
  end

  describe '#post' do
    subject { refund_reversal.post.response }

    context 'when required parameters are given' do
      let(:order_number) { { order_number: '23473341' } }
      let(:credit_number) { { credit_number: '14949449'} }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refundreversal").
          with(body: default_backend_request_hash.merge(
            {
              "creditNumber"=>"14949449",
              "orderNumber"=>"23473341",
              "requestFingerprint"=>"4f92a11fb765e115e9c7e2e89ff1b08692fb61f7cce1aac88ab5afec4dc61d9d76ff1e72ccd18b836232177df29c03f5e4416c61c7954275e5a8fe9026545e5c"
            }
          )).
          to_return(
            status: 200,
            body: "status=0",
            headers: {}
          )
      end

      it { is_expected.to eq({ status: "0" }) }

      context 'when required parameters are not given' do
        let(:order_number) { Hash.new }
        let(:credit_number) { Hash.new }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refundreversal").
            with(body: default_backend_request_hash.merge(
              {
                "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&error.2.errorCode=11013&error.2.message=Credit+number+is+missing.&error.2.consumerMessage=Credit+number+is+missing.&errors=2&status=1",
              headers: {}
            )
        end

        it { is_expected.to eq({
           :"error.1.consumer_message" => "Order number is missing.",
           :"error.1.error_code" => "11011",
           :"error.1.message" => "Order number is missing.",
           :"error.2.consumer_message" => "Credit number is missing.",
           :"error.2.error_code" => "11013",
           :"error.2.message" => "Credit number is missing.",
           errors: "2",
           status: "1"
           }) }
      end
    end
  end
end