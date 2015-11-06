require 'spec_helper'

RSpec.describe Wirecard::Backend::TransferFund::ExistingOrder do

  let(:transfer_fund_existing_order) { Wirecard::Backend::TransferFund::ExistingOrder.new(options) }
  let(:options) { Hash.new.merge(amount).merge(currency).merge(fund_transfer_type).merge(order_description).merge(source_order_number).merge(credit_number).merge(customer_statement).merge(order_number).merge(order_reference) }
  let(:amount) { { amount: '1000' } }
  let(:currency) { { currency: 'EUR'} }
  let(:fund_transfer_type) { { fund_transfer_type: 'EXISTINGORDER'} }
  let(:order_description) { { order_description: 'some description'} }
  let(:source_order_number) { { source_order_number: '23473341'} }
  let(:credit_number) { { credit_number: '14949449'} }
  let(:customer_statement) { { customer_statement: 'invoice text'} }
  let(:order_number) { { order_number: '56453412'} }
  let(:order_reference) { { order_reference: 'MercantID F34545'} }

  include_context 'configuration'

  it { is_expected.to be_a_kind_of(Wirecard::Backend::TransferFund::ExistingOrder) }

  describe '#implicit_fingerprint_order' do
    subject { transfer_fund_existing_order.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :credit_number, :order_description, :amount, :currency, :order_reference, :customer_statement, :fund_transfer_type, :source_order_number]) }
  end

  describe '#defaults' do
    subject { transfer_fund_existing_order.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end

  describe '#url' do
    subject { transfer_fund_existing_order.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/transferfund') }
  end

  describe '#post' do
    subject { transfer_fund_existing_order.post.response }

    context 'when required parameters are given' do
      let(:amount) { { amount: '1000' } }
      let(:currency) { { currency: 'EUR'} }
      let(:fund_transfer_type) { { fund_transfer_type: 'EXISTINGORDER'} }
      let(:order_description) { { order_description: 'some description'} }
      let(:source_order_number) { { source_order_number: '23473341'} }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/transferfund").
          with(body: default_backend_request_hash.merge(
            {
              "amount"=>"1000",
              "creditNumber"=>"14949449",
              "currency"=>"EUR",
              "customerStatement"=>"invoice text",
              "fundTransferType"=>"EXISTINGORDER",
              "orderDescription"=>"some description",
              "orderNumber"=>"56453412",
              "orderReference"=>"MercantID F34545",
              "requestFingerprint"=>"9514833a4bc44c6c13c320a04ae55d4ae1dabf6c99645f01658dd6f6370f49f8806de59e7dbdb1f8b75994e57e011c347d7908650164955b43f28a7a8d11127b",
              "sourceOrderNumber"=>"23473341"
            }
          )).
          to_return(
            status: 200,
            body: "status=0&creditNumber=14949449",
            headers: {}
          )
      end

      it { is_expected.to eq({ credit_number: '14949449', status: '0' }) }

      context 'when optional parameters not are given' do
        let(:credit_number) { Hash.new }
        let(:customer_statement) { Hash.new }
        let(:order_number) { Hash.new }
        let(:order_reference) { Hash.new }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/transferfund").
            with(body: default_backend_request_hash.merge(
              {
                "amount"=>"1000",
                "currency"=>"EUR",
                "fundTransferType"=>"EXISTINGORDER",
                "orderDescription"=>"some description",
                "requestFingerprint"=>"403782c9e852642fd0dbdbf21ca741c92f1c7df7ab18aece4cec68171d5d9cc59647a56aa539714228413e582973a9c7e31f79036d02bcf77ae2af289d4d662d",
                "sourceOrderNumber"=>"23473341"
              }
            )).
            to_return(
              status: 200,
              body: "status=0&creditNumber=14949449",
              headers: {}
            )
        end

        it { is_expected.to eq({ credit_number: '14949449', status: '0' }) }
      end
    end

    context 'required parameters are not given' do
      let(:amount) { Hash.new }
      let(:currency) { Hash.new }
      let(:fund_transfer_type) { Hash.new }
      let(:order_description) { Hash.new }
      let(:source_order_number) { Hash.new }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/transferfund").
          with(body: default_backend_request_hash.merge(
            {
              "creditNumber"=>"14949449",
              "customerStatement"=>"invoice text",
              "orderNumber"=>"56453412",
              "orderReference"=>"MercantID F34545",
              "requestFingerprint"=>"8e12d164fd45310ba0772e9c81c0362fb133ee9a137a2071acba359f1608c687e046604e8f58988c84c6d1bed1949c3ef437cad13599287b5801529445838b83"
            }
          )).
          to_return(
            status: 200,
            body: "error.1.errorCode=11017&error.1.message=Amount+is+missing.&error.1.consumerMessage=Amount+is+missing.&error.2.errorCode=11019&error.2.message=Currency+is+missing.&error.2.consumerMessage=Currency+is+missing.&error.3.errorCode=11020&error.3.message=Order+description+is+missing.&error.3.consumerMessage=Order+description+is+missing.&error.4.errorCode=11216&error.4.message=FUNDTRANSFERTYPE+is+missing.&error.4.consumerMessage=FUNDTRANSFERTYPE+is+missing.&errors=4&status=1",
            headers: {}
          )
      end

      it { is_expected.to eq({
         :"error.1.consumer_message" => "Amount is missing.",
         :"error.1.error_code" => "11017",
         :"error.1.message" => "Amount is missing.",
         :"error.2.consumer_message" => "Currency is missing.",
         :"error.2.error_code" => "11019",
         :"error.2.message" => "Currency is missing.",
         :"error.3.consumer_message" => "Order description is missing.",
         :"error.3.error_code" => "11020",
         :"error.3.message" => "Order description is missing.",
         :"error.4.consumer_message" => "FUNDTRANSFERTYPE is missing.",
         :"error.4.error_code" => "11216",
         :"error.4.message" => "FUNDTRANSFERTYPE is missing.",
         errors: "4",
         status: "1"
      }) }
    end
  end
end