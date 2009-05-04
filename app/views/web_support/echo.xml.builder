xml.instruct! :xml, :version => "1.0"

xml.echo do |echo|
  echo.method @method
  echo.uri @uri
  echo.headers @headers
  echo.body @body
end
