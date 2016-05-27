require "json"

class TransactionParser

  attr_reader :transaction

    def initialize abs_filename
      @contents = JSON.parse File.read abs_filename
      @path = [abs_filename]
      @transaction = []
  end

    def parse!
      #binding.pry
      @contents.each do |transaction|
        @transaction.push transaction
      end

      # remove original data from the object

      remove_instance_variable(:@contents)
    end
end
