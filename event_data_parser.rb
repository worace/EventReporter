class EventDataParser
  require 'csv'
  require './queue'
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  attr_accessor :attendees

  def load_attendees (file)
    file.rewind
    self.attendees = file.collect {|line| Attendee.new(line) }
  end

  def initialize(filename, options = CSV_OPTIONS)
    load_attendees(CSV.open(filename, CSV_OPTIONS))
  end


  def self.load(filename)
    puts "Loading data from #{filename}"
  end

  def self.valid_parameters?(parameters)
    parameters.count == 1 && parameters =~ /\.csv$/
  end

  def print_attendees
    self.attendees.each do |attendee|
      puts [attendee.full_name, attendee.zipcode, attendee.phone_number.to_s, 
        attendee.state].join("\t")
    end
  end

end

