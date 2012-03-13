class Search
  def search_for(parameters)
    "Searching for #{parameters}"
  end

  def self.valid_parameters?(parameters)
    parameters.count == 2
    # TODO: Should also check that attribute is valid
  end
end