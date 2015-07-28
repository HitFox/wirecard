RSpec.shared_examples 'configuration' do
  let(:default_config) { {
    host: 'checkout.wirecard.com',
    endpoint: 'https://checkout.wirecard.com/seamless',
    customer_id: 'D200001',
    shop_id: 'qmore',
    secret: 'B8AKTPWBRMNBV455FG6M2DANE99WU2',
    success_url: 'http://localhost.success.url',
    failure_url: 'http://localhost.failure.url',
    cancel_url: 'http://localhost.cancel.url',
    service_url: 'http://localhost.service.url',
    confirm_url: 'http://localhost.confirm.url',
    return_url: 'http://localhost.return.url',
    language: 'en'
   } }
   
  before do
    Wirecard.configure do |config|
      binding.pry
      config.host = config[:host]
      config.endpoint = config[:endpoint]
      config.customer_id = config[:customer_id]
      config.shop_id = config[:shop_id]
      config.secret = config[:secret]
      config.success_url = config[:success_url]
      config.failure_url = config[:failure_url]
      config.cancel_url = config[:cancel_url]
      config.service_url = config[:service_url]
      config.confirm_url = config[:confirm_url]
      config.return_url = config[:return_url]
      config.language = config[:language]
    end
  end
end

