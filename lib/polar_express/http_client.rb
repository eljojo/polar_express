require "net/https"
require "uri"

module PolarExpress
  class HTTPClient
    attr_accessor :old_tls, :use_ssl

    def initialize(opts = {})
      config = {
        old_tls: true,
        use_ssl: nil,
      }.merge(opts)

      @old_tls = config[:old_tls]
      @use_ssl = config[:use_ssl]
      @connection = nil
    end

    def get(url)
      uri = get_uri(url)
      opened_before = !!@connection
      open(uri) unless @connection

      req = Net::HTTP::Get.new(uri)
      req.basic_auth uri.user, uri.password if uri.user
      result = @connection.request(req).body

      close unless opened_before
      result
    end

    def post(url, params)
      uri = get_uri(url)
      opened_before = !!@connection
      open(uri) unless @connection

      req = Net::HTTP::Post.new(uri)
      req.form_data = params
      req.basic_auth uri.user, uri.password if uri.user
      result = @connection.request(req).body

      close unless opened_before
      result
    end

    def open(url)
      close
      uri = get_uri(url)
      @connection = Net::HTTP.new(uri.host, uri.port)
      prepare_connection(uri)
      @connection.start
    end

    def close
      if @connection.is_a?(Net::HTTP) then
        @connection.finish if @connection.started?
      end
      @connection = nil
    end

  private
    def get_uri(string_or_uri)
      if string_or_uri.is_a?(String)
        URI.parse(string_or_uri)
      else
        string_or_uri
      end
    end

    def prepare_connection(uri)
      @connection.use_ssl = @use_ssl.nil? ? uri.scheme == 'https' : @use_ssl
      @connection.ssl_version = @old_tls == true ? :TLSv1 : nil
    end
  end
end
