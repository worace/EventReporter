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
require 'logger'

module Kernel
  def log(message)
    logger.info(message)
  end

  def logger
    @@logger ||= Logger.new("dev.log")
  end
end

module EventReporter
  class CLI
    EXIT_COMMANDS = ["quit", "q", "e", "exit"]

    def self.parse_user_input(input)
      [ input.first.downcase, input[1..-1] ]
    end

    def self.prompt_user
      puts "enter command > "
      gets.strip.split
    end

    def self.run
      puts "Welcome to the EventReporter"
      command = ""
      @reporter = Command.new
      until EXIT_COMMANDS.include?(command)    
        inputs = prompt_user
        log "Starting a command from CLI.run"

        if EXIT_COMMANDS.include?(inputs[0])
          command, parameters = parse_user_input(inputs)
          puts "Goodbye"
        elsif inputs.any?
          command, parameters = parse_user_input(inputs)
          @reporter.execute(command, parameters)
          puts result
        else
          puts "No command entered."
        end
      end
    end

  end
end

EventReporter::CLI.run
