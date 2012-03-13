require './event_data_parser'
require './queue'
require './help'
require './search'

module EventReporter
  class Command
    ALL_COMMANDS = {"load" => "loads a new file",
                   "help" => "shows a list of available commands",
                   "queue count" => "total items in the queue",
                   "queue clear" => "empties the queue",
                   "queue print" => "prints to the queue",
                   "queue print by" => "prints the specified attribute",
                   "queue save to" => "exports queue to a CSV",
                   "queue" => "The queue contains items from search",
                   "find" => "load the queue with matching records"}

    def self.valid?(command)
      ALL_COMMANDS.keys.include?(command)
    end

   def self.execute(command, parameters)
      if command == "load" && EventDataParser.valid_parameters?(parameters)
        @file = EventDataParser.new(parameters[0])
        puts "Loaded #{parameters[0]}"     
        # else
        #   puts "Sorry, you specified invalid arguments. Use this format:"
        #   puts "load filename.csv"
      elsif command == "queue" && Queue.valid_parameters?(parameters)
          Queue.new.call(parameters)
        # else
          # puts "Sorry, you specified invalid arguments for queue."
      elsif command == "help" && Help.valid_parameters?(parameters)
          Help.new.help_for(parameters)
        # else
        #   error_message(command)
      elsif command == "find" && Search.valid_parameters?(parameters)
          Search.new.search_for(parameters)
      else
        error_message(command)
      end
    end

    def self.error_message(command)
      "Sorry, you specified invalid arguments for #{command}"
    end

  end
end