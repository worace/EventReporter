require './session'

module EventReporter
  class Help
    HELP = {
     "load"           => "Type 'load <filename.csv>' to load a new file.",
     "queue count"    => "Type 'queue count' to display the number of records currently in the queue.",
     "queue clear"    => "Type 'queue clear' to empty the queue.",
     "queue print"    => "Type 'queue print' to display all records in the queue.",
     "queue find"     => "Type 'queue find <attribute> <value>' to return all entries whose <attribute> matches the <value> ",
     "queue print by" => "Type 'queue print by <attribute>' to display all records in the queue, sorted by the specified attribute.",
     "queue save to"  => "Type 'queue save to <filename>' to export the current queue to a CSV file.",
     "queue"          => "The queue contains records from previous searches.",
     "find"           => "Type 'queue find <attribute> <value>' to return all entries whose <attribute> matches the <value> ",
     "quit"           => "Type 'quit' or 'exit' to leave EventReporter."
     }


    def help_for(parameters)
      if parameters.count > 0 && HELP.keys.include?(parameters.join(" "))
        HELP[parameters.join(" ")]
      else
        "Here are some available commands: #{HELP.keys.join(" | ")} \n Type 'help <command>' for more info."
      end
    end

  end
end