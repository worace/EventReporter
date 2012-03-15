require './event_data_parser'
require './queue'
require './help'
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
        load(params[0])
      elsif command == "load" && params.count == 0
        load()
      elsif command == "queue" && Queue.valid_params?(params)
        @queue = Queue.call(params)
      elsif command == "find" && Queue.valid_params?(params.unshift("find"))
        @queue = Queue.call(params, @attendees)
      elsif command == "help"
          Help.new.help_for(params)
      elsif command == "add" && Queue.valid_parameters?(parameters[1..-1])
      else
        error_message(command)
      end
    end

    def load (filename = "event_attendees.csv")
      @attendees = EventDataParser.new(filename)
      puts "Loaded #{@attendees.count} attendees!"
      @queue = Queue.call(["clear"])
    end

    def error_message(command)
        "Sorry, you specified invalid arguments for #{command}"
    end

  end
end