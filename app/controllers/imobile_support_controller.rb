class ImobileSupportController < ApplicationController
  protect_from_forgery :except => [:payment_receipt, :push_notification]

  # Don't log the push certificates. They're ugly and it's not cool.
  filter_parameter_logging :certificate

  def payment_receipt
    production = params[:production] || 'false'
    production = production.read unless production.respond_to? :to_str
    production = (production == 'true')
    
    receipt = params[:receipt] || ''
    receipt = receipt.read unless receipt.respond_to? :to_str 
    
    # UTF-8 --> ASCII
    # TODO(costan): should Rails have done this for us?
    receipt = receipt.unpack('U*').pack('C*')    
    if RAILS_ENV == 'development'
      File.open('/tmp/receipt', 'w') { |f| f.write receipt }
    end
    
    server_type = production ? :production : :sandbox
    if params[:receipt].blank?
      @receipt = false
    else
      @receipt = Imobile.validate_receipt receipt, server_type
    end

    respond_to do |format|
      format.html # store_receipt.html.erb
      format.json { render :json => { :response => @receipt } }
    end
  end
  
  def push_notification
    certificate_blob = params[:certificate]    
    
    notification = params[:notification]
    device_info = params[:device]
    if certificate_blob and device_info
      # UTF-8 --> ASCII
      # TODO(costan): should Rails have done this for us?
      certificate_blob = certificate_blob.unpack('U*').pack('C*') 
      
      push_token = Imobile.pack_hex_push_token device_info[:app_push_token]
      notification[:push_token] = push_token
      Imobile.push_notification notification, certificate_blob
    end
    
    respond_to do |format|
      format.html # push_notification.html.erb
      format.json { render :json => { :response => { :status => :ok }}}
    end
  end
end
