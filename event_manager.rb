# Dependencies
require 'csv'
require 'sunlight'

# Class Definition
class EventManager
  #constant for replacing "nil" zipcodes
  INVALID_ZIPCODE = "00000"
  Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

  def initialize (file_name)
    puts "EventManager Initialized."
    @file = CSV.open(file_name, {:headers => true, :return_headers => true, :header_converters => :symbol})
  end

  def print_names
    puts "Printing First and Last Names."
    @file.each do |line|
      puts [line[:first_name], line[:last_name]].join(" ")
    end
  end

  def clean_phone_numbers(original)
    clean = original.scan(/\d/).join
    #check length
    #if length is 10: OK
    if clean.length == 10
        length_checked = clean
      #or, if length is 11: check for leading "1"
      elsif clean.length == 11 && clean[0]==1
        #if leading "1", delete
        length_checked = clean[1..-1]
      #else: is effed
      else
        length_checked = "0"*10
    end
    return length_checked
  end

  def print_numbers
    puts "Printing Home Phone Numbers."
    @file.each do |line|
    puts clean_phone_numbers(line[:homephone])
    end
  end

  def print_names_with_numbers
    @file.each do |line|
      puts [line[:first_name], line[:last_name], clean_phone_numbers(line[:homephone])].join(" ")
    end
  end

  def clean_zipcodes(zipcode)
    if zipcode.nil?
      zipcode = INVALID_ZIPCODE
    end

    if zipcode.length < 5
      clean_zipcode = [0*(5-zipcode.length), zipcode].join
    else
      clean_zipcode = zipcode
    end
    return clean_zipcode
  end

  def print_zipcodes
    @file.each do |line|
      zipcode = line[:zipcode]
      puts clean_zipcodes(zipcode)
    end
  end

  #Output cleaned data to new file
  def output_data (file_name)
    output = CSV.open(file_name, "w", {:headers => true, :header_converters => :symbol})
    @file.rewind
    @file.each do |line|
      if @file.lineno == 0
        output << line.headers
      else
        line[:homephone] = clean_phone_numbers(line[:homephone])
        line[:zipcode] = clean_zipcodes(line[:zipcode])
        output << line
      end
    end
    puts "Wrote Data to #{file_name}"
  end
  
  def rep_lookup (file_name)
    puts "Reading from #{file_name}"
    read_file = CSV.open(file_name, {:headers => true, :header_converters => :symbol})

    20.times do
      line = read_file.readline
      legislators = Sunlight::Legislator.all_in_zipcode(clean_zipcodes(line[:zipcode]))
        names = legislators.collect do |legislator|
          party = legislator.party
          title = legislator.title
          first_name = legislator.firstname
          first_initial = first_name[0]
          last_name = legislator.lastname
          title + ". " + first_initial + ". " + last_name + " (" + party + ")"
        end
      puts [line[:first_name], line[:last_name], line[:zipcode], names.join(", ")].join(", ")
    end
  end

  def rank_times (file_name)
    puts "Reading from #{file_name}"
    read_file = CSV.open(file_name, {:headers => true, :header_converters => :symbol})
    hours = Array.new(24){0}

    read_file.each do |line|
      timestamp = line[:regdate]
      hour = timestamp.split(" ")[1].split(":")[0]
      hours[hour.to_i] += 1
    end
      hours.each_with_index{|counter,hour| puts "#{hour}\t#{counter}"}
  end

  def day_stats (file_name)
    puts "Counting Day Stats from #{file_name}"
    read_file = CSV.open(file_name, {:headers => true, :header_converters => :symbol})
    days = Array.new(7){0}

    read_file.each do |line|
      timestamp = line[:regdate]
      date_str = timestamp.split(" ")[0]
      date = Date.strptime(date_str, "%m/%d/%Y")
      days[date.wday] +=1
    end
    days.each_with_index{|counter,day| puts "#{day}\t#{counter}"}
  end

  def state_stats (file_name)
    puts "Counting State Stats for #{file_name}"
    read_file = CSV.open(file_name, {:headers => true, :header_converters => :symbol})
    state_data = {}

    read_file.each do |line|
      state = line[:state]
      if state.nil? 
        state = "No State Given"
      end
      if state_data[state].nil?
        state_data[state] = 1
      else
        state_data[state] += 1
      end 
    end

    state_data_bystate = state_data.sort_by{|state, counter| state unless state.nil?}
    state_data_bycount = state_data.sort_by{|state, counter| counter unless state.nil?}

    puts "States and Attendees by State"
    state_data_bystate.each do |key,value|
      puts key.to_s + ":  " + value.to_s
    end

    puts "States and Attendees by Count"
    counter = 0
    state_data_bycount.each do |key,value|
      counter += 1
      puts key.to_s + ":  " + value.to_s + "\t" + "Rank: " + counter.to_s
    end

    state_ranks = state_data.sort_by{|state,counter| counter}.collect
  end
end

# Script
manager = EventManager.new("event_attendees.csv")
#manager.print_names
#manager.print_numbers
#manager.print_names_with_numbers
#manager.print_zipcodes
manager.output_data("event_attendees_clean.csv")
#manager.rep_lookup("event_attendees_clean.csv")
#manager.rank_times("event_attendees_clean.csv")
#manager.day_stats("event_attendees_clean.csv")
manager.state_stats("event_attendees_clean.csv")


