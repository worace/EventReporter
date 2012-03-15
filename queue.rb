require 'csv'
require './event_data_parser'
require 'ruby-debug'

module EventReporter
  class Queue
    include Enumerable

    def each(&block)
      @queue.each(&block)
    end

    def initialize
      @queue = []
    end



    def self.call(params)
      "Running Queue sub-function #{params[0]}"
      case params[0]
      when "find" then find(params)
      when "clear" then clear
      when "count" then @queue.count.to_s
      when "print" then 
        if params[0..1].join(" ") == "print by"
          print_by(params)
        else print
        end
      when "save" then save_to(params)
      # find
      end
    end

    def self.valid_parameters?(parameters)
      if !%w(count clear print save find).include?(parameters[0])
        false
      elsif parameters[0] == "print" 
        parameters.count == 1 || (parameters.count == 3 && parameters[1] == "by")
      elsif parameters[0] == "save"
        parameters.count == 1 || (parameters.count ==3 && parameters[1] == "to")
      elsif parameters[0] == "find"
        parameters.count == 3 #&& Attendee.keys.include?(params[1])
      else
        true
      end
    end

    def self.print (params=[])
      paddings = {}
      # debugger
      @queue.first.keys.each do |key|
        @queue.sort_by{|attendee| attendee.send(key).length}
        paddings[key] = @queue.last.send(key).length
      end

      headers = @queue.first.keys
      headers.each {|header| printf header.to_s.rjust(paddings[header.to_sym].to_i + 6)}
      puts ""
      @queue.each do |attendee|
        attendee.keys.each {|key| printf attendee.send(key).rjust(paddings[key.to_sym].to_i + 6)}
        puts "\n"
      end
    end

    def self.print_by(params)
      @queue = @queue.sort_by{|attendee| attendee.send(params[2])}
      print
    end

    def self.clear
      @queue = []
      puts @queue.inspect
      return @queue
    end

    def self.find(params)
      puts "Going to find based on these params: #{params.join("\t")}"
      @event_data_parser = params[-1]
      attribute = params[1].to_s
      criterion = params[2].to_s
      @queue = @event_data_parser.select {|attendee| attendee.send(attribute) == criterion}
      puts @queue[0..10].inspect
    end

    def self.save_to(params)
    #expect filename as last param
    output = CSV.open(params[2].to_s, "w", {:headers => true, :header_converters => :symbol})
    
    output << @queue.first.keys # ---- TODO How to write the headers in the CSV file?
    @queue.each do |attendee|
      output << attendee.keys.collect {|key| attendee.send(key)}
    end
    puts "Wrote Data to #{params[2]}"
  end

  end
end