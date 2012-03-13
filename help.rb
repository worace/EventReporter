class Help
  require './command'

  def help_for(parameters)
    puts "Here's help for #{parameters}"
  end

  def self.valid_parameters?(parameters)
    parameters.empty? || Command.valid_command?(parameters.join(" "))
  end

end