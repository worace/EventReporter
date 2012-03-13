class EventDataParser
  def self.load(filename)
    puts "Loading data from #{filename}"
  end

  def self.valid_parameters?(parameters)
    parameters.count == 1 && parameters =~ /\.csv$/
  end

end
