require "date"
require "set"
require 'base64'
require 'uri'
require 'net/http'
require 'net/https'

require 'json'


# The code for verifying a In-App Purchase receipt.
#
# This code is implicitly tested when ZergSupport is tested. 
module ImobileSupport::PaymentReceipt
  def self.verify(receipt, production = true)
    receipt = receipt.read unless receipt.respond_to? :to_str 

    # Set up the HTTP request.
    uri = store_uri production
    request = Net::HTTP::Post.new uri.path
    request.set_content_type 'application/json'
    request.body = {'receipt-data' => Base64.encode64(receipt) }.to_json
    
    # Fetch the response.
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = (uri.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http_response = http.request request
    unless http_response.kind_of? Net::HTTPSuccess
      raise "Apple service error -- #{http_response.inspect}"
    end
    
    # Process the response.
    response = JSON.parse http_response.body
    return false unless response['status']
    receipt = response['receipt'] 

    # Bonus: parse out dates in the JSON.
    ['purchase-date', 'original-purchase-date',
     'purchase_date', 'original_purchase_date'].each do |prop|
       receipt[prop] &&= DateTime.parse receipt[prop]
    end
    receipt
  end
  
  def self.store_uri(production = true)
    uri_string = production ? "https://buy.itunes.apple.com/verifyReceipt" :
        "https://sandbox.itunes.apple.com/verifyReceipt"
    URI.parse uri_string
  end
end
