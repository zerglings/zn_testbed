xml.instruct! :xml, :version => "1.0"

xml.fprint do |echo|
  echo.data @data
  echo.hex_md5 @hex_md5
end
