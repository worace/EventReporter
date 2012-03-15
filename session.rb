require './event_data_parser'
require './queue'
require './help'
require './search'
require 'ruby-debug'

# Processes input queue find last_name Williams as follows:
# command = "queue"
# params = ["find", "last_name", "Williams", @attendees]
# where @attendees is an EventDataParser based off of loaded CSV file

module EventReporter
  class Session
    ALL_COMMANDS = {"load" => "loads a new file",
                   "help" => "shows a list of available commands",
                   "queue count" => "total items in the queue",
                   "queue clear" => "empties the queue",
                   "queue print" => "prints to the queue",
                   "queue print by" => "prints the specified attribute",
                   "queue save to" => "exports queue to a CSV",
                   "queue" => "The queue contains items from search",
                   "find" => "load the queue with matching records"}

    def valid?(command)
      ALL_COMMANDS.keys.include?(command)
    end


    def execute(command, params)
      @attendees = [] unless @attendees
      if command == "load" && EventDataParser.valid_parameters?(params)
        @attendees = EventDataParser.new(params[0])
        puts "Loaded #{@attendees.count} attendees!"  
        @queue = Queue.call(["clear"])
      elsif command == "load" && params.count == 0
        @attendees = EventDataParser.new("event_attendees.csv")
        @queue = Queue.call(["clear"])
        puts "Loaded #{@attendees.count} attendees!"  
      elsif command == "queue" && Queue.valid_parameters?(params)
        @queue = Queue.call(params)
      elsif command == "find" && Queue.valid_parameters?(params.unshift("find"))
        @queue = Queue.call(params, @attendees)
      #Exception for help: allow "bad input" to enter into 
      #help method, so user can get help
      elsif command == "help" #&& Help.valid_parameters?(parameters)
          Help.new.help_for(params)
      elsif command == "add" && Queue.valid_parameters?(parameters[1..-1])
      else
        error_message(command)
      end
    end

    def error_message(command)
        "Sorry, you specified invalid arguments for #{command}"
    end

  end
end