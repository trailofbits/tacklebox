require 'tackle_box/person'

module TackleBox
  class Organization

    # The name of the organization.
    #
    # @return [String]
    attr_reader :name

    # The primary domain of the organization.
    #
    # @return [String]
    attr_reader :domain

    # The website of the organization.
    #
    # @return [String]
    attr_reader :website

    # The industry sector of the organization.
    #
    # @return [String]
    attr_reader :industry

    # The people belonging to the organization.
    #
    # @return [Array<Person>]
    attr_reader :people

    #
    # Initializes the organization.
    #
    # @param [String] name
    #
    # @option options [String] :domain
    #
    # @option options [String] :website
    #
    # @option options [String] :industry
    #
    def initialize(name,options={})
      @name = name

      @domain   = options[:domain]
      @website  = options.fetch(:website) do
        "http://#{@domain}" if @domain
      end
      @industry = options[:industry]

      @people = []
    end

    #
    # Adds a person to the organization.
    #
    # @param [String] address
    #   Email address for the person.
    #
    # @param [Hash] options
    #   Additional options, see {Person#initialize}.
    #
    def person(address,options={})
      @people << Person.new(address,options)
    end

    #
    # Searches for people in the given department.
    #
    # @param [String] dept
    #   The department to search against.
    #
    # @return [Array<Person>]
    #   The people belonging to that department.
    #
    def people_in_department(dept)
      @people.find { |person| person.department == dept }
    end

    #
    # Searches for people from a given location.
    #
    # @param [String] loc
    #   The location to search against.
    #
    # @return [Array<Person>]
    #   The people in that location.
    #
    def people_from_location(loc)
      @people.find { |person| person.location == loc }
    end

    #
    # Converts the organization to a liquid Hash.
    #
    # @return [Hash{String => String,nil}]
    #   The liquid hash containing:
    #   
    #   * `name`
    #   * `domain`
    #   * `website`
    #   * `industry`
    #
    def to_liquid
      {
        'name'     => @name,
        'domain'   => @domain,
        'website'  => @website,
        'industry' => @industry
      }
    end

    #
    # Converts the organization to a String.
    #
    # @return [String]
    #   The name of the organization.
    #
    def to_s
      @name
    end

  end
end
