require 'spec_helper'

RSpec.describe Wirecard::DataStorage::Init do
  
  let(:init) { Wirecard::DataStorage::Init.new(options) }
  let(:options) { Hash.new }
  
  before { Wirecard::Base.config = config }
  let(:config) { { customer_id: 'customer1', shop_id: 'shop1' } }
  
  it { is_expected.to be_a_kind_of(Wirecard::DataStorage::Init) }
  
  describe '#implicit_fingerprint_order' do
    subject { init.implicit_fingerprint_order }
    
    it { is_expected.to eq([:customer_id, :shop_id, :order_ident, :return_url, :language, :javascript_script_version, :secret]) }
  end
  
  describe '#defaults' do
    subject { init.defaults }
    
    include_examples 'Wirecard::Base#defaults'
    it { expect(subject[:javascript_script_version]).to eq('pci3') }
    
    context 'when defaults are overwritten' do
      let(:options) { { customer_id: 'special_customer_id', shop_id: 'special_shop_id' } }
      
      it { expect(subject[:customer_id]).to eq(options[:customer_id]) }
      it { expect(subject[:customer_id]).not_to eq(config[:customer_id]) }
      
      it { expect(subject[:shop_id]).to eq(options[:shop_id]) }
      it { expect(subject[:shop_id]).not_to eq(config[:shop_id]) }
    end
  end
  
end