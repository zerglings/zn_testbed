require 'digest/md5'
require 'digest/sha2'
require 'openssl'

# The code for verifying a ZergSupport application finger-print.
#
# This code is as official as it gets -- it's used in the unit tests.
module CryptoSupport::AppFprint
  def self.hex_fprint(manifest, device_attributes)
    cipher = OpenSSL::Cipher::Cipher.new 'aes-128-cbc'
    cipher.encrypt
    cipher.key = CryptoSupport::DeviceFprint.raw_md5 device_attributes
    cipher.iv = "\0" * 16
    
    plain = manifest + "\0" * ((16 - (manifest.length & 0x0f)) & 0x0f)
    crypted = cipher.update plain
    Digest::SHA2.hexdigest crypted
  end
end
