require 'digest/md5'

class CryptoSupportController < ApplicationController
  protect_from_forgery :except => [:app_fprint, :device_fprint]
  
  def device_fprint
    attrs = params[:attributes] || {}
    
    # Reference code for how the digests are computed.
    @data = CryptoSupport::DeviceFprint.fprint_data attrs
    @hex_md5 = CryptoSupport::DeviceFprint.hex_md5 attrs
    
    respond_to do |format|
      format.html # device_fprint.html.erb
      format.xml  # device_fprint.xml.builder
    end
  end
  
  def app_fprint
    attrs = params[:attributes] || {}
    manifest = params[:manifest] || ' '
    
    # UTF-8 --> ASCII
    # TODO(overmind): should Rails have done this for us?
    manifest = manifest.unpack('U*').pack('C*')
    
    @hex_fprint = CryptoSupport::AppFprint.hex_fprint manifest, attrs

    respond_to do |format|
      format.html # app_fprint.html.erb
      format.xml  # app_fprint.xml.builder
    end
  end
end
