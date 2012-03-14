require 'csv'

module EventReporter
  class Attendee
    # takes a CSV Row
    # assigns to appropriate instance variables


    attr_accessor :regdate, :last_name, :first_name, :email, :homephone,
                  :street, :city, :state, :zipcode, :keys

    def initialize(csv_line = {})
      self.keys = csv_line.headers
      self.regdate = csv_line[:regdate]
      self.last_name = csv_line[:last_name]
      self.first_name = csv_line[:first_name]
      self.email = csv_line[:email]
      self.homephone = csv_line[:homephone]
      self.street = csv_line[:street]
      self.city = csv_line[:city]
      self.state = csv_line[:state]
      self.zipcode = csv_line[:zipcode]
    end

    def full_name
      [first_name, last_name].join(" ")
    end

    def zipcode
      Zipcode.clean(@zipcode)
    end

    def phone_number
      PhoneNumber.new(@homephone)
    end

    def state
      State.clean(@state)
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
