class ImobileSupportController < ApplicationController
  protect_from_forgery :except => [:payment_receipt]

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
end
