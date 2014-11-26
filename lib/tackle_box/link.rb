require 'uri'

module TackleBox
  class Link

    #
    # Initializes the link.
    #
    # @param [String, URI::HTTP] link
    #   The URI of the link.
    #
    def initialize(link)
      @url = URI(link)
    end

    #
    # The domain that is serving the link.
    #
    # @return [String]
    #
    def domain
      @url.host
    end

    #
    # Converts the link into a liquid hash.
    #
    # @return [Hash{String => Integer,String}]
    #   The liquid hash containing:
    #   
    #   * `url`
    #   * `scheme`
    #   * `host`
    #   * `port`
    #   * `path`
    #   * `query`
    #
    def to_liquid
      {
        'url'    => @url.to_s,
        'scheme' => @url.scheme,
        'host'   => @url.host,
        'port'   => @url.port,
        'path'   => @url.path,
        'query'  => @url.query
      }
    end

    #
    # Converts the link to a String.
    #
    # @return [String]
    #
    def to_s
      @url.to_s
    end

  end
end
