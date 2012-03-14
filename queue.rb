require 'csv'
require './event_data_parser'
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
      when "count" then @queue.count
      when "print" then print
      # save
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
        parameters.count == 3
      else
        true
      end
    end

    def self.print (params=[])
      headers = @queue.first.keys
      headers.each {|header| printf header.to_s.ljust(20)}
      @queue.each do |attendee|
        attendee.values.each {|value| printf value.to_s.ljust(10)}
      # each{|value| print value.ljust(15)}
      end
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
      # puts @queue.inspect
    end

  end
end