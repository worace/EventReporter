require 'csv'
require './event_data_parser'
require 'ruby-debug'

module EventReporter
  class Queue
    HEADERS = [:regdate, :last_name, :first_name, :email_address,
        :homephone, :street, :city, :state, :zipcode]
    include Enumerable

    def each(&block)
      @queue.each(&block)
    end

    def self.initialize
      @queue = []
    end

    def self.call(params, attendees = [])
      "Running Queue sub-function #{params[0]}"
      case params[0]
      when "find" then find(params, attendees)
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
        parameters.count >= 3 #&& Attendee.keys.include?(params[1])
      else
        true
      end
    end

    def self.print (params=[])
      unless @queue.empty?
        paddings = {}
        # debugger
        @queue.first.keys.each do |key|
          @queue.sort_by{|attendee| attendee.send(key).length if attendee}
          paddings[key] = @queue.last.send(key).length
        end

        headers = @queue.first.keys
        headers.each {|header| printf header.to_s.rjust(paddings[header.to_sym].to_i + 6)}
        puts ""
        @queue.each do |attendee|
          attendee.keys.each {|key| printf attendee.send(key).rjust(paddings[key.to_sym].to_i + 6)}
          puts "\n"
        end
      else
        HEADERS.each {|header| printf header.to_s.rjust(header.to_s.length + 6)}
        puts "\n\n\t\tNO ATTENDEES TO DISPLAY"
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

    def self.find(params, attendees)
      puts "Searching for #{params[1]}: \t #{params[2..-1].join(" ")}"
      @event_data_parser = attendees
      attribute = params[1].to_s
      criterion = params[2..-1].join(" ")
      @queue = @event_data_parser.select do |attendee|
        attendee.send(attribute).downcase == criterion.downcase
      end
      puts "Found #{@queue.count} attendees."
    end

    def self.save_to(params)
    #expect filename as last param
    unless @queue.empty?
      CSV.open(params[2].to_s, "w", {:headers => true, :header_converters => :symbol}) do |output|
        output << @queue.first.keys
        @queue.each do |attendee|
          output << attendee.keys.collect {|key| attendee.send(key)}
        end
        puts "Wrote Data to #{params[2]}"
      end
    else
      CSV.open(params[2].to_s, "w", {:headers => true, :header_converters => :symbol}) do |output|
        output << HEADERS
        end
        puts "Wrote Data to #{params[2]}"
    end
  end

  end
end