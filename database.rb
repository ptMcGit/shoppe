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
