require 'net/https'

# gotten from: https://github.com/stevegraham/certified/blob/master/certified.rb

Net::HTTP.class_eval do
  alias _use_ssl= use_ssl=

  def use_ssl= boolean
    self.ca_file     = "#{File.dirname(__FILE__)}/certs/cacert.pem"
    self.verify_mode = OpenSSL::SSL::VERIFY_PEER
    self._use_ssl    = boolean
  end
end
