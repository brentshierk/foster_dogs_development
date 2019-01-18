class QueryService
  attr_reader :organization

  def initialize(organization:)
    @organization = organization
  end
end
