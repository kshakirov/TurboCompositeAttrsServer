require "openssl"
require "digest"
require "uri"
require "base64"

class CustomerInfoDecypher
  def decypher encrypted_info
    begin
      data = encrypted_info
      key = "uUxJIpSKMbOQQdtm6Y4rPEXeE9TAKUns"
      aes = OpenSSL::Cipher::AES.new(256, :ECB)
      aes.padding = 0
      aes.decrypt
      aes.key = key
      aes.update(data.unpack('m')[0]) + aes.final
    rescue Exception => e
      return ""
    end
  end

  def get_customer_group encrypted_info
    info = decypher encrypted_info
    segments = info.split(':')
    if segments.size < 2 or segments[1].include? 'not_authorized'
      'no stats'
    else
      segments[1]
    end
  end

  def test
    get_customer_group 'FKVHLg5P6MRI37pkVLfZNg=='
  end

end