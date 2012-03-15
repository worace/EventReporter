require 'csv'
require 'ruby-debug'

module EventReporter
  class Attendee
    #constant to define Keys array matching CSV Headers
    KEYS = [:regdate, :last_name, :first_name, :email_address,
        :homephone, :street, :city, :state, :zipcode]

    attr_accessor :regdate, :last_name, :first_name, :email_address,
                  :homephone, :street, :city, :state, :zipcode, :keys

    def initialize(csv_line = {})
      self.keys = KEYS
      self.regdate = csv_line[:regdate]
      self.last_name = clean_name(csv_line[:last_name])
      self.first_name = clean_name(csv_line[:first_name])
      self.email_address = csv_line[:email_address].to_s
      self.homephone = clean_phone_number(csv_line[:homephone])
      self.street = csv_line[:street].to_s
      self.city = csv_line[:city].to_s
      self.state = clean_state(csv_line[:state])
      self.zipcode = clean_zipcode(csv_line[:zipcode])
    end

    def values
      values = @keys.collect{|key| self.send(key)}
    end

    def to_s (key_order=@keys)
      attendee_strings = key_order.collect{|key| self.send(key)}
    end

    def to_hash
      attendee = self.keys {|key| attendee[key] = self.send(key)}
    end

    def clean_zipcode(zipcode)
      zipcode.to_s.rjust(5, "0")
    end
    
    def clean_phone_number(phone_number)
      clean = phone_number.scan(/\d/).join
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

    def clean_name(name)
      name.capitalize
    end

    def clean_email(email_address)
      email_address.to_s
    end

    def clean_state(state)
      state.to_s[0..1].upcase
    end

  end

  class RegDate
    def self.clean(regdate)
    end
  end

  class Zipcode
    def self.clean(dirty_zipcode)
      dirty_zipcode.to_s.rjust(5, "0")
    end
  end

  class State
    def self.clean(state)
      state.to_s[0..1].upcase
    end
  end

  class PhoneNumber
    def initialize (phone_number)
      @phone_number = phone_number.scan(/\d/).join
    end

    def to_s
      "(#{@phone_number[0..2]}) #{@phone_number[3..5]}-#{@phone_number[6..-1]}"
    end
  end
end
