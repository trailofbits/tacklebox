module TackleBox
  class Attachment

    # The path to the file to attach
    attr_reader :path

    # The desired name of the attachment
    attr_reader :name

    # The contents for the attachment
    attr_reader :content

    # The encoding of the attachment
    attr_reader :encoding

    # The password for the attachment
    attr_reader :password

    #
    # Initializes the attachment.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :name
    #   The desired name for the attachment.
    #   Defaults to the basename of the path.
    #
    # @option options [String] :content
    #   The optional contents for the attachment.
    #   Defaults to the contents of the file.
    #
    # @option options [String] :encoding
    #   The encoding of the attachment (ex: `zip`, `7z`, `rar`).
    #   Defaults to the extension of the attachment name.
    #
    # @option options [String] :password
    #   The password for the attachment.
    #
    # @raise [ArgumentError]
    #   Either `:path` or `:content` must be specified, or `:name`
    #
    # @example Use an existing file:
    #   Attachment.new(path: 'path/to/nudes.exe')
    #
    # @example Use an existing file but with a different name:
    #   Attachment.new(path: 'path/to/nudes.exe', name: 'nudes.jpg')
    #
    # @example Specify a custom name and contents:
    #   Attachment.new(name: 'nudes.jpg', content: data)
    #
    def initialize(options={})
      unless (options[:path] || options[:content])
        raise(ArgumentError,"must specify :path or :content")
      end

      @path = options[:path]
      @name = options.fetch(:name) do
        unless @path
          raise(ArgumentError,":path or :name are required")
        end

        File.basename(@path)
      end

      @content = options.fetch(:content) do
        File.binread(@path)
      end

      @encoding = options.fetch(:encoding) do
        File.extname(@name)[1..-1]
      end

      @password = options[:password]
    end

    #
    # Converts the attachment into a liquid hash.
    #
    # @return [Hash{String => String,nil}]
    #   The liquid hash containing:
    #
    #   * `name`
    #   * `encoding`
    #   * `password`
    #
    def to_liquid
      {
        'name'     => @name,
        'encoding' => @encoding,
        'password' => @password
      }
    end

  end
end
