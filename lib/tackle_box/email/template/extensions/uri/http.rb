require 'uri/http'

module URI
  class HTTP < Generic

    #
    # Breaks the HTTP URI down into a liquid Hash of it's components.
    #
    # @return [Hash{String => String}]
    #   The liquid Hash containing `url`, `scheme`, `host`, `port`, `path`
    #   and `query`.
    #
    def to_liquid
      {
        'url'    => self.to_s,
        'scheme' => self.scheme,
        'host'   => self.host,
        'port'   => self.port,
        'path'   => self.path,
        'query'  => self.query
      }
    end

  end
end
