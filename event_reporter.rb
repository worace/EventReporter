require 'csv'
require './attendee'
require './event_reporter_cli'

class EventReporter


end

  cli = EventReporterCLI

# er = EventReporter.new('event_attendees.csv')



# er.attendees.each do |attendee|
#   puts [attendee.full_name, attendee.zipcode, attendee.phone_number.to_s, 
#         attendee.state].join("\t")
# end


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