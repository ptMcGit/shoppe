class DataBase
  attr_reader :tables
  def initialize *tables
    @tables = {}
    tables.flatten.each do |table|
      if @tables.keys.include? table.name
        @tables[table.name] += table.data
      else
        @tables[table.name] = table.data
      end
    end
    @tables
  end

  def add_table name, table
    @tables[name] = table
    return @tables[name]
  end

  def join_tables table1, field1, table2, field2
    # REVERSE THESE => join table2 table1
    table = []

    table2.each do |h2|
      table.push [h2, table1.select { |h1| h1[field1] == h2[field2] }[0]].reduce(:merge)

    end
    return table
  end

  def sum_by table, id_field, qty_field
    h = Hash.new(0)
    table.each do |hash|
      h[hash[id_field]] += hash[qty_field]
    end

    h = h.map { |k,v| Hash["name"=>k,"total"=>v]}
    return h
  end

  def sum_column table, field
    table.map { |h| h[field] }.reduce :+
  end

  def get_values table, field
    table.map { |h| h[field] }
  end

  def extend_table table, field1, field2
    table.each do |h|
      h["ext"] = h[field1] * h[field2]
    end
    return table
  end

  def max_record table, field
    table.max_by { |h| h[field] }
  end

  def unique_record table, unique_field, value
    return table.select { |h| h[unique_field] == value }.first
  end

  def filter_by_value table, field, *values
    return table.select { |h| values.flatten.include? h[field] }
  end


  def ensure_array data
    case data
    when Array
      return data
    when String
      return data.split
    when Hash
      return data.to_a
    end
  end

  def add_data data
    @data.concat ensure_array(data)
  end

#  def deduplicate!
    # remove duplicate objects
    #    binding.pry
    #entries_to_delete = []
#    count = @users.count
#    binding.pry
#    0.upto (@users.count - 1) do |index|
#      @users.delete_if { |user2| (!user2.equal? @users[index]) && (user2.address == @users[index].address) && (user2.id == @users[index].id) && (user2.name == @users[index].name) }

  #@users.delete duplicate_entries
  #  end
   # binding.pry
#  end
end

class DbTable

  attr_reader :name, :data

  def initialize name, data
    @name = name
    @data = data
  end
end
