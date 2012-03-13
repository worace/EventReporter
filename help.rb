class Help
  ALL_COMMANDS = {"load" => "loads a new file",
                 "help" => "shows a list of available commands",
                 "queue count" => "total items in the queue",
                 "queue clear" => "empties the queue",
                 "queue print" => "prints to the queue",
                 "queue print by" => "prints the specified attribute",
                 "queue save to" => "exports queue to a CSV",
                 "queue" => "The queue contains items from search",
                 "find" => "load the queue with matching records"}

  def help_for(parameters)
    puts "Here's help for #{parameters}"
  end

  def self.valid_command?(command)
    ALL_COMMANDS.keys.include?(command)
  end

  def self.valid_parameters?(parameters)
    parameters.empty? || valid_command?(parameters.join(" "))
  end

end