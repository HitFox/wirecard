require 'spec_helper'

RSpec.describe Wirecard::Backend::RecurPayment do

  let(:recur_payment) { Wirecard::Backend::RecurPayment.new(options) }
  let(:options) { Hash.new.merge(amount).merge(currency).merge(order_description).merge(source_order_number).merge(auto_deposit).merge(customer_statement).merge(order_number).merge(order_reference) }
  let(:amount) { { amount: '1000'} }
  let(:currency) { { currency: 'EUR' } }
  let(:order_description) { { order_description: 'some description'} }
  let(:source_order_number) { { source_order_number: '23473341'} }
  let(:auto_deposit) { { auto_deposit: 'Yes' } }
  let(:customer_statement) { { customer_statement: 'some statement' } }
  let(:order_number) { { order_number: '23473341' } }
  let(:order_reference) { { order_reference: 'MercantID_X345456' } }

  include_context 'configuration'

  it { is_expected.to be_a_kind_of(Wirecard::Backend::RecurPayment) }

  describe '#implicit_fingerprint_order' do
    subject { recur_payment.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :source_order_number, :auto_deposit, :order_description, :amount, :currency, :order_reference, :customer_statement]) }
  end

  describe '#defaults' do
    subject { recur_payment.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end

  describe '#url' do
    subject { recur_payment.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/recurpayment') }
  end

  describe '#post' do
    subject { recur_payment.post.response }

    context 'when required parameters are given' do
      let(:amount) { { amount: '1000'} }
      let(:currency) { { currency: 'EUR' } }
      let(:order_description) { { order_description: 'some description'} }
      let(:source_order_number) { { source_order_number: '23473341'} }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/recurpayment").
          with(body: default_backend_request_hash.merge(
            {
              "amount"=>"1000",
              "currency"=>"EUR",
              "customerStatement"=>"some statement",
              "orderDescription"=>"some description",
              "orderNumber"=>"23473341",
              "sourceOrderNumber"=>"23473341",
              "autoDeposit"=>"Yes",
              "orderReference"=>"MercantID_X345456",
              "requestFingerprint"=>"aceb23e9015a4b84fbafd0e0498d526c7e92ca4e7a96fe4ca7c042852271d46e8c54dd217eb1ddaf3a343f9f170fb52629e4a91b8fabd9f13e6c4b2df0077b6f"
            }
          )).
          to_return(
            status: 200,
            body: "status=0&orderNumber=23473341",
            headers: {}
          )
      end

      it { is_expected.to eq({ order_number: "23473341", status: "0" }) }

      context 'when required parameters are not given' do
        let(:amount) { Hash.new }
        let(:currency) { Hash.new }
        let(:order_description) { Hash.new }
        let(:source_order_number) { Hash.new }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/recurpayment").
            with(body: default_backend_request_hash.merge(
              {
                "customerStatement"=>"some statement",
                "orderNumber"=>"23473341",
                "autoDeposit"=>"Yes",
                "orderReference"=>"MercantID_X345456",
                "requestFingerprint"=>"a2170fe58a24491b64e57fe08c18f9711faa819051cdae13cabb85c46a93d6fc844abb9fa85857d02d806caf6a54e4b74ab89487b35564deafce432a30de9609"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11159&error.1.message=Source+ORDERNUMBER+is+missing.&error.1.consumerMessage=Source+ORDERNUMBER+is+missing.&error.2.errorCode=11020&error.2.message=Order+description+is+missing.&error.2.consumerMessage=Order+description+is+missing.&error.3.errorCode=11017&error.3.message=Amount+is+missing.&error.3.consumerMessage=Amount+is+missing.&error.4.errorCode=11019&error.4.message=Currency+is+missing.&error.4.consumerMessage=Currency+is+missing.&errors=4&status=1",
              headers: {}
            )
        end

        it { is_expected.to eq({
           :"error.1.consumer_message" => "Source ORDERNUMBER is missing.",
           :"error.1.error_code" => "11159",
           :"error.1.message" => "Source ORDERNUMBER is missing.",
           :"error.2.consumer_message" => "Order description is missing.",
           :"error.2.error_code" => "11020",
           :"error.2.message" => "Order description is missing.",
           :"error.3.consumer_message" => "Amount is missing.",
           :"error.3.error_code" => "11017",
           :"error.3.message" => "Amount is missing.",
           :"error.4.consumer_message" => "Currency is missing.",
           :"error.4.error_code" => "11019",
           :"error.4.message" => "Currency is missing.",
           errors: "4",
           status: "1"
           }) }
      end

      context 'when optional parameters are not given' do
        let(:auto_deposit) { Hash.new }
        let(:customer_statement) { Hash.new }
        let(:order_number) { Hash.new }
        let(:order_reference) { Hash.new }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/recurpayment").
            with(body: default_backend_request_hash.merge(
              {
                "amount"=>"1000",
                "currency"=>"EUR",
                "orderDescription"=>"some description",
                "sourceOrderNumber"=>"23473341",
                "requestFingerprint"=>"aa3ea63cc812e30d1b2a412e8e24dbc26d3379dbe1b7c5ca672cc67d42aa45e0dc8454e5de07635aa3514449ff3bb7792d40ecc086a0a7c252119380cc738f40"
              }
            )).
            to_return(
              status: 200,
              body: "status=0&orderNumber=23473341",
              headers: {}
            )
        end

        it { is_expected.to eq({ order_number: "23473341", status: "0" }) }
      end

    end
  end
end