module TackleBox
  class Person

    # The email address for the person
    #
    # @return [String]
    attr_reader :address

    # The person's name
    #
    # @return [String, nil]
    attr_reader :name

    # The person's job title
    #
    # @return [String, nil]
    attr_reader :title

    # The person's department
    #
    # @return [String, nil]
    attr_reader :department

    # The person's physical location.
    #
    # @return [String, nil]
    attr_reader :location

    #
    # Initializes the person.
    #
    # @param [String] address
    #   The email address of the person.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :name
    #   The name of the person.
    #
    # @option options [String] :title
    #   The job title of the person.
    #
    # @option options [String] :department
    #   The department the person works in.
    #
    def initialize(address,options={})
      @address = address

      @name         = options[:name]
      @title        = options[:title]
      @department   = options[:department]
      @location     = options[:location]
    end

    #
    # Converts the person to a liquid Hash.
    #
    # @return [Hash{String => String,nil}]
    #   The liquid hash containing:
    #   
    #   * `name`
    #   * `address`
    #   * `title`
    #   * `department`
    #
    def to_liquid
      {
        'name'       => @name,
        'address'    => @address,
        'title'      => @title,
        'department' => @department,
        'location'   => @location
      }
    end

    #
    # Converts the person to a String.
    #
    # @return [String]
    #   The person's name and address.
    #
    def to_s
      if @name then "#{@name} <#{@address}>"
      else          @address.to_s
      end
    end

  end
end
