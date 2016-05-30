def is_a_transaction_file? json_parsed_file
  t = [json_parsed_file[0].update(Hash[json_parsed_file[0].map { |k,v| [k, v.class]}])]
  return t.hash == TransactionParser::TransactionFilePattern.hash
end

require "./transaction_id"
class TransactionParser

  attr_reader :transaction, :TransactionParserPattern

  TransactionFilePattern = [
    {"timestamp" => String,
    "user_id"   => Fixnum,
    "item_id"   => Fixnum,
    "quantity"  => Fixnum}
  ]

  def initialize abs_filename
    @contents = JSON.parse File.read abs_filename
    @path = abs_filename
    @transaction = []
  end

  def parse!
    @contents.each do |transaction|
      transaction["unique_id"] = TransactionID.new
      @transaction.push transaction
    end

    # remove original data from the object

    remove_instance_variable(:@contents)
  end
end
