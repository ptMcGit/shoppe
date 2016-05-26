require "json"

class TransactionParser

  attr_reader :transaction

    def initialize abs_filename
      @contents = JSON.parse File.read abs_filename
      @transaction = []
  end

    def parse!
      @contents.each do |transaction|
        @transaction.push transaction
      end
    end
end
