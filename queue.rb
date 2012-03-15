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
      case params[0]
      when "find" then find(params, attendees)
      when "clear" then clear
      when "count" then @queue.count.to_s
      when "print" then print(params)
      when "save" then save_to(params)
      end
    end

    def self.print(params)
      if params[0..1].join(" ") == "print by"
        print_by(params)
      else
        simple_print
      end
    end

    def self.valid_params?(params)
      if !%w(count clear print save find).include?(params[0])
        false
      elsif params[0] == "print"
        params.count == 1 || (params.count == 3 && params[1] == "by")
      elsif params[0] == "save"
        params.count == 1 || (params.count ==3 && params[1] == "to")
      elsif params[0] == "find"
        params.count >= 3
      else
        true
      end
    end

    def self.simple_print (params=[])
      unless @queue.empty?
        paddings = {}
        # debugger
        @queue.first.keys.each do |key|
          @queue.sort_by{|attendee| attendee.send(key).length if attendee}
          paddings[key] = @queue.last.send(key).length
        end

        headers = @queue.first.keys
        headers.each do |header|
          printf header.to_s.rjust(paddings[header.to_sym].to_i + 9)
        end
        puts ""
        @queue.each do |attendee|
          attendee.keys.each do |key|
            printf attendee.send(key).rjust(paddings[key.to_sym].to_i + 9)
          end
          puts "\n"
        end
      else
        HEADERS.each do|header|
          printf header.to_s.rjust(header.to_s.length + 9)
        end
        puts "\n\n\t\tNO ATTENDEES TO DISPLAY"
      end
    end

    def self.print_by(params)
      @queue = @queue.sort_by{|attendee| attendee.send(params[2])}
      simple_print
    end

    def self.clear
      @queue = []
      puts "Emptied the queue"
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
        normal_save(params)
      else
        empty_save(params)
      end
    end

    def self.normal_save(params)
      CSV.open(params[2].to_s, "w",
        {:headers => true, :header_converters => :symbol}) do |output|
          output << @queue.first.keys
          @queue.each do |attendee|
            output << attendee.keys.collect {|key| attendee.send(key)}
          end
        end
      puts "Wrote Data to #{params[2]}"
    end

    def self.empty_save(params)
      CSV.open(params[2].to_s, "w",
          {:headers => true, :header_converters => :symbol}) do |output|
          output << HEADERS
          end
          puts "Wrote Data to #{params[2]}"
    end
  end
end