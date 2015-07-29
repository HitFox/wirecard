require 'spec_helper'

RSpec.describe Wirecard::DataStorage::Init do
  
  let(:init) { Wirecard::DataStorage::Init.new(options) }
  let(:options) { { order_ident: 'order123' } }
  
  include_examples 'configuration'
  
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
    subject { init.post }
    include_examples 'stub requests'
    
    context 'when order_ident is given' do
      it { is_expected.to eq ({javascript_url: "https://checkout.wirecard.com/seamless/dataStorage/js/D200001/qmore/b2737b746627482e0b024097cadb1b41/dataStorage.js",
                              storage_id: "b2737b746627482e0b024097cadb1b41"}) }
    end
    
    context 'when order_ident is missing' do
      let(:options) { Hash.new }
      
      it { is_expected.to eq ({:"error.1.consumer_message" => "ORDERIDENT has an invalid length.",
                               :"error.1.error_code" => "15300",
                               :"error.1.message" => "ORDERIDENT has an invalid length.",
                               errors: "1",}) }
    end
  end
end