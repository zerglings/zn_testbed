require 'digest/md5'

# The code for verifying a ZergSupport device finger-print.
#
# This code is as official as it gets -- it's used in the unit tests.
module CryptoSupport::DeviceFprint
  def self.fprint_data(device_attributes)
    'D|' + device_attributes.keys.sort.map { |k| device_attributes[k] }.join('|')
  end
  
  def self.raw_md5(device_attributes)
    Digest::MD5.digest self.fprint_data(device_attributes) 
  end

  def self.hex_md5(device_attributes)
    Digest::MD5.hexdigest self.fprint_data(device_attributes) 
  end
end
