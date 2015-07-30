RSpec.shared_examples 'Wirecard::Base#defaults' do
  it { expect(subject[:customer_id]).to eq(config[:customer_id]) }
  it { expect(subject[:shop_id]).to eq(config[:shop_id]) }
end

RSpec.shared_examples 'Wirecard::Backend::Base#defaults' do
  it { expect(subject[:password]).to eq(config[:password]) }
  it { expect(subject[:language]).to eq(config[:language]) }
end