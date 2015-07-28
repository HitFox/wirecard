require 'spec_helper'

RSpec.describe Wirecard::DataStorage::Read do
  
  let(:read) { Wirecard::DataStorage::Read.new(options) }
  let(:options) { { storage_id: 'b2737b746627482e0b024097cadb1b41' } }
  
  include_examples 'configuration'
  
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
    subject { read.post }
    include_examples 'stub requests'

    context 'when storage_id is given' do
      it { is_expected.to eq ({payment_informations: '0',
                              storage_id: "b2737b746627482e0b024097cadb1b41"}) }
    end

    context 'when storage_id is missing' do
      let(:options) { Hash.new }

      it { is_expected.to eq ({:"error.1.error_code" => "11302",
                              :"error.1.message" => "STORAGEID is missing.",
                              errors: '1'}) }
    end
  end
end