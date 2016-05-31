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
    h = table.map { |h| Hash["name",h["name"],"total", 0] }.uniq

    table.each do |hash|
      h.select { |e| e[id_field] == hash[id_field]}[0]["total"] += hash[qty_field]
    end
    return h
  end

  def max_record table, field
    table.max_by { |h| h[field] }
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
      #binding.pry


 #     binding.pry
      #binding.pry
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
