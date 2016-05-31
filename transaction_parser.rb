def is_a_transaction_file? json_parsed_file
  t = [json_parsed_file[0].update(Hash[json_parsed_file[0].map { |k,v| [k, v.class]}])]
  return t.hash == TransactionParser::TransactionFilePattern.hash
end

class TransactionParser

  attr_reader :transaction, :TransactionParserPattern

  TransactionFilePattern = [
    {"timestamp" => String,
    "user_id"   => Fixnum,
    "item_id"   => Fixnum,
    "quantity"  => Fixnum}
  ]

  def initialize abs_filename
    @path = abs_filename
    @transaction = []
  end

  def parse!
    raw = JSON.parse File.read @path
    @transaction = []

    raw.each do |transaction|
      @transaction.push Transaction.new transaction
    end
  end

  def fix_name symbol_from_iv
    symbol_from_iv.to_s.gsub(/^@/,"")
  end

  def datafy
    return TransactionTable.new("transaction", self.transaction)
  end
end

class TransactionTable

  attr_reader :name, :data

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
