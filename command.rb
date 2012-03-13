require './event_data_parser'
require './queue'
require './help'
require './search'

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
    if command == "load"        
      if EventDataParser.valid_parameters?(parameters)
        EventDataParser.load(parameters[0])          
      else
        puts "Sorry, you specified invalid arguments. Use this format:"
        puts "load filename.csv"
      end
    elsif command == "queue"
      if Queue.valid_parameters(parameters)
        Queue.new.call(parameters)
      else
        puts "Sorry, you specified invalid arguments for queue."
      end
    elsif command == "help"
      if Help.valid_parameters?(parameters)
        Help.new.help_for(parameters)
      else
        puts "Sorry, you specified invalid arguments for help"
      end
    elsif command == "find"
      if Search.valid_parameters?(parameters)
        Search.new.search_for(parameters)
      else
        puts "sorry you specified invalid arguments"
      end
    end
  end



end