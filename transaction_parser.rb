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
      @transaction.push Transaction.new transaction
    end

    # remove original data from the object

    remove_instance_variable(:@contents)
  end

  def fix_name symbol_from_iv
    symbol_from_iv.to_s.gsub(/^@/,"")
  end

  def datafy
    return TransactionTable.new(fix_name(i), self.transaction)
  end
end

class TransactionTable
  def initialize name, transaction_parser_data
    @name = name
    @data = []
    transaction_parser_data.each do |o|
      h = {}
      h["key"] = o.object_id
      o.instance_variables.each do |i|
        o.instance_variable_get(i).each do |k,v|
          h[k] = v
        end
      end
      @data.push h
    end
  end
end
