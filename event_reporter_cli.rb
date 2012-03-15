require './event_data_parser'
require './queue'
require './help'
require './search'
require './session'

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
      @command = ""
      @reporter = Session.new
      until EXIT_COMMANDS.include?(@command)
        command_loop
      end
    end

    def self.command_loop
      inputs = prompt_user
      if EXIT_COMMANDS.include?(inputs[0])
        @command, parameters = parse_user_input(inputs)
        puts "Goodbye"
      elsif inputs.any?
        @command, parameters = parse_user_input(inputs)
        result = @reporter.execute(@command, parameters)
        puts result if result.is_a?(String)
      else
        puts "No command entered."
      end
    end
  end
end

EventReporter::CLI.run
