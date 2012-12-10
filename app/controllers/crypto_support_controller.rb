class CryptoSupportController < ApplicationController
  protect_from_forgery :except => [:app_fprint, :device_fprint]

  def device_fprint
    attrs = params[:attributes] || {}

    # Reference code for how the digests are computed.
    @data = Imobile::CryptoSupportAppFprint.device_fprint_data attrs
    @hex_md5 = Imobile::CryptoSupportAppFprint.hex_device_fprint attrs

    # In development mode, save the finger-print for test case generation.
    if RAILS_ENV == 'development'
      File.open('/tmp/device_fprint', 'w') do |f|
        f.write attrs.inspect + "\n" + @hex_md5 + "\n"
      end
    end

    respond_to do |format|
      format.html # device_fprint.html.erb
      format.xml  # device_fprint.xml.builder
    end
  end

  def app_fprint
    attrs = params[:attributes] || {}
    manifest = params[:manifest] || ' '
    manifest = manifest.read unless manifest.respond_to? :to_str

    # UTF-8 --> ASCII
    # TODO(costan): should Rails have done this for us?
    manifest = manifest.unpack('U*').pack('C*')

    @hex_fprint =
        Imobile::CryptoSupportAppFprint.app_fprint_from_raw_data attrs, manifest

    respond_to do |format|
      format.html # app_fprint.html.erb
      format.xml  # app_fprint.xml.builder
    end
  end
end
