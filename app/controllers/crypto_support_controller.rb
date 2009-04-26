require 'digest/md5'

class CryptoSupportController < ApplicationController
  protect_from_forgery :except => [:device_fprint]
  
  def device_fprint
    attrs = params[:attributes] || {}
    
    # Reference code for how the digests are computed.
    @data = 'D|' + attrs.keys.sort.map { |k| attrs[k] }.join('|')
    @hex_md5 = Digest::MD5.hexdigest @data
    
    respond_to do |format|
      format.html # device_fprint.html.erb
      format.xml  # device_fprint.xml.builder
    end
  end
end
