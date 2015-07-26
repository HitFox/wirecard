require "wirecard/version"
require "wirecard/base"
require "wirecard/request"
require "wirecard/response"
require "wirecard/data_storage/base"
require "wirecard/data_storage/init"
require "wirecard/data_storage/read"
require "wirecard/fingerprint/base"
require "wirecard/fingerprint/sha_512"
require "wirecard/payment_process/init"

module Wirecard
  autoload :Base, 'wirecard/base'
  autoload :Request, 'wirecard/request'
  autoload :Response, 'wirecard/response'
  autoload :Base, 'wirecard/data_storage/base'
  autoload :Init, 'wirecard/data_storage/init'
  autoload :Read, 'wirecard/data_storage/read'
  autoload :Base, 'wirecard/fingerprint/base'
  autoload :Sha512, 'wirecard/fingerprint/sha_512'
  autoload :Init, 'wirecard/payment_process/init'
end
