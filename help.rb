require './command'

module EventReporter
  class Help

    def help_for(parameters)
      "Here's help for #{parameters}"
    end

    def self.valid_parameters?(parameters)
      parameters.empty? || Command.valid?(parameters.join(" "))
    end

  end
end