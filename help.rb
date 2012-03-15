require './session'

module EventReporter
  class Help
    HELP = {
    "load" => "Type 'load <filename.csv>' to load a new file.",
    "queue count" => "Type 'queue count' to show # of queue results.",
    "queue clear" => "Type 'queue clear' to empty the queue.",
    "queue print" => "Type 'queue print' to display all records in the queue.",
    "print" => "Type 'queue print' to display all records in the queue.",
    "queue find" => "Type 'queue find <attribute> <value>' to find matches",
    "queue print by" => "'queue print by <attribute>' prints sorted results",
    "queue save to" => "Type 'queue save to <filename>' to export a CSV",
    "queue" => "The queue contains records from previous searches.",
    "find" => "Type 'queue find <attribute> <value>' to find matching entries",
    "quit" => "Type 'quit' or 'exit' to leave EventReporter."
     }


    def help_for(parameters)
      if parameters.count > 0 && HELP.keys.include?(parameters.join(" "))
        HELP[parameters.join(" ")]
      else
        "Here are some available commands: #{HELP.keys.join(" | ")} \n"
      end
    end

  end
end