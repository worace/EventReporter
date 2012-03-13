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
require './command'


class EventReporterCLI
  EXIT_COMMANDS = ["quit", "q", "e", "exit"]

  def self.parse_user_input(input)
    [ input.first.downcase, input[1..-1] ]
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
        Command.execute(command, parameters)
      else
        puts "No command entered."
      end
    end
  end

end

EventReporterCLI.run
