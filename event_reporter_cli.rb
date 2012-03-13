# COMMANDS
# load <filename>
# queue COUNT
# queue CLEAR
# queue PRINT
# queue PRINT by <attribute>
# queue SAVE to <filename>
# find <attribute> <criteria>
# help
# Generic Form:
# First Position          Second Position
# [load|help|queue|find] (filename|command|count|clear|print|save|attribute)
# Imagined uses (starters)
# load event_attendees.csv
# help
# help load
# help queue
# 
# dividing: split? reg ex? 
require './event_data_parser'
require './queue'
require './help'
require './search'

class EventReporterCLI
  EXIT_COMMANDS = ["quit", "q", "e", "exit"]
  ALL_COMMANDS = {"load" => "loads a new file",
                 "help" => "shows a list of available commands",
                 "queue count" => "total items in the queue",
                 "queue clear" => "empties the queue",
                 "queue print" => "prints to the queue",
                 "queue print by" => "prints the specified attribute",
                 "queue save to" => "exports queue to a CSV",
                 "queue" => "The queue contains items from search",
                 "find" => "load the queue with matching records"}

  def self.parse_user_input(input)
    [ input.first.downcase, input[1..-1] ]
  end

  def self.valid_command?(command)
    ALL_COMMANDS.keys.include?(command)
  end

 def self.switch_by_command(command, parameters)
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

  def self.prompt_user
      puts "enter command > "
      inputs = gets.strip.split
  end

  def self.run
    puts "Welcome to the EventReporter"
    command = ""

    until EXIT_COMMANDS.include?(command)    
      inputs = prompt_user

      if inputs.any?
        command, parameters = parse_user_input(inputs)
        switch_by_command(command, parameters)
      else
        puts "No command entered."
      end
    end
  end

end

EventReporterCLI.run
