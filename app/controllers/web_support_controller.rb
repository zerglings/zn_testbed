class WebSupportController < ApplicationController
  protect_from_forgery :except => [:echo]
  
  def echo
    forbidden_hdrs = ['X_REAL_IP'];
    headers = request.headers.to_a.map { |hdr|
         [hdr.first.to_s, hdr.last] }.select { |hdr|
         /^HTTP/ =~ hdr.first }.reject { |hdr|
         forbidden_hdrs.include? hdr.first }
    @headers = headers.map { |hdr| "#{hdr.first[5..-1]}: #{hdr.last}\n" }.
                       sort.join
         
    respond_to do |format|
      format.html # 
      format.xml { render :xml => { :headers => @headers,
                                    :method => request.method,
                                    :body => request.body.string } }
    end
  end
end
