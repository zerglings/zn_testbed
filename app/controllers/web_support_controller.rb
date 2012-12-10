require 'csv'

class WebSupportController < ApplicationController
  protect_from_forgery :except => [:csv, :echo]

  def echo
    forbidden_hdrs = ['X_REAL_IP', 'X_FORWARDED_FOR', 'X_FORWARDED_PROTO',
                      'X_HEROKU_DYNOS_IN_USE', 'X_HEROKU_QUEUE_DEPTH',
                      'X_HEROKU_QUEUE_WAIT_TIME',
                      'X_HEROKU_USER', 'X_REQUEST_START', 'X_VARNISH'];
    headers = request.headers.to_a.map { |hdr|
      [hdr.first.to_s, hdr.last]
    }.select { |hdr|
      /^HTTP/ =~ hdr.first
    }.reject { |hdr|
      forbidden_hdrs.include? hdr.first[5..-1]
    }
    @uri = url_for
    @headers = headers.map { |hdr| "#{hdr.first[5..-1]}: #{hdr.last}\n" }.sort
    @method = request.method.to_s
    @body = request.body.string
    respond_to do |format|
      format.json do
        render :json => { :echo => { :headers => @headers,
                                     :method => @method,
                                     :body => @body,
                                     :uri => @uri } }
      end
      format.html # echo.html.erb
      format.xml # echo.xml.builder
    end
  end

  def csv
    render :text => CSV.generate_line(params[:data])
  end
end
