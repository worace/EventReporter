require 'csv'
require './attendee'

class EventReporter
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  attr_accessor :attendees

  def initialize(filename, options = CSV_OPTIONS)
    load_attendees(CSV.open(filename, CSV_OPTIONS))
  end

  def load_attendees (file)
    file.rewind
    self.attendees = file.collect {|line| Attendee.new(line) }
  end

  # def help("")
  #   #List available commands for given argument
  #   # or, if no params given, simply list all options
  # end


  #method for controlling command loop vv


end

er = EventReporter.new('event_attendees.csv')



er.attendees.each do |attendee|
  puts [attendee.full_name, attendee.zipcode, attendee.phone_number.to_s, 
        attendee.state].join("\t")
end


  # def print_names
  #   attendees.each do |attendee|
  #     puts attendee.full_name
  #   end
  # end

  # def print_zipcodes
  #   attendees.each do |attendee|
  #     puts attendee.zipcode
  #   end
  # end

  # def print_phone_number
  #   attendees.each do |attendee|
  #     puts attendee.phone_number
  #   end
  # end