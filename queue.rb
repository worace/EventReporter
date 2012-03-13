require 'csv'
module EventReporter
  class Queue
  # "Queue" acts as a data structure for holding current query results
  #  queue will act as an array of Attendee objects

    def initialize
      @queue = []
    end

    def call(params)
      "Running Queue sub-function #{params[0]}"

      # clear
      # print
      # save
      # find
    end

    def self.valid_parameters?(parameters)
      if !%w(count clear print save).include?(parameters[0])
        false
      elsif parameters[0] == "print" 
        parameters.count == 1 || (parameters.count == 3 && parameters[1] == "by")
      elsif parameters[0] == "save"
        parameters.count == 1 || (parameters.count ==3 && parameters[1] == "to")
      else
        true
      end
    end

    def clear
    end

    def find ()
    end

  end
end
  # def clear
  #   # wipes the queue (return empty queue object?)
  # end

  # def print()
  #   # prints current queue contents - tab-delimited with headers for category
  #   # if given "attribute", sort by that attribute (array of hashes sorted by hash{:attribute}?)

  #   # XXXEXTENSIONSXXX
  #   # - format: print in left-aligned cols where col width is == longest_entry.length
  #   #     -- use "max" to find longest, make ljust based on length of longest
  #   # - behavior: if queue.length > 10, pause after 10 lines until user input USE SLICE
  # end

  # def save ("filename.csv")
  #   # write current queue to file with given name
  #   # will always be CSV? if so, just take filename?

  #   # XXXEXTENSIONSXXX
  #   # output: generate files for other filetypes (csv, txt, json, xml)
  # end


  # def find ("attribute", "criteria")
  #   # **Find is responsible for instantiating queue
  #   # find records with criteria for attribute & load these into current queue
  #   # level 1: exact matches

  #   # XXXEXTENSIONSXXX
  #   # Queue Math
  #   # - add "subtract"/"add" methods for searching to add or remove matching entries from queue
  #   # NIGHTMARE FIND
  #   # - accept multiple params for given attribute; 
  #   # - OR searches: match either attribute
  #   # - find within existing queue results (self method? find without wiping queue first?)
  # end
# end