require "json"

def is_a_data_file? json_parsed_file
  a = json_parsed_file
  a.keys.each do |e|
    if a[e].empty?
      next
    end
    a[e].pop a[e].count - 1
    a[e][0] = Hash[a[e][0].map { |k,v| [k, v.class] }]
  end
  return DataParser::DataFilePatterns.include? a
end

class DataParser

  attr_reader :path, :users, :items, :DataFilePattern

  DataFilePatterns =
    [
      {
        "users"=>[{ "id"        => Fixnum,
                    "name"      => String}],
    "items"=>[{ "id"         => Fixnum,
                "name"       => String,
                "category"   => String,
                "price"      => Float}]
      },
      {
      "users"=>[{"id"     => Fixnum,
                 "name"   => String,
                "address" => String}],
      "items"=>[]
      },
      {
        "items"=>[{ "id"            => Fixnum,
                    "name"          => String,
                    "category"      => String,
                    "price"         => Float}],
        "users"=>[{"id"         => Fixnum,
                   "name"       => String,
                   "address"    => String}],
      }
    ]

  def initialize abs_filename
    @contents = JSON.parse File.read abs_filename
    @path = abs_filename
    @users = []
    @items = []
  end

  def parse!
    @contents["users"].each do |user|
      h = {}
      user.each do |key, value|
        h[key] = value
      end
      @users.push(
        User.new(
        h["id"],
        h["name"],
        h["address"])
      )
    end

    @contents["items"].each do |item|
      h = {}
      item.each do |key, value|
        h[key] = value
      end
      @items.push(
        Item.new(
        h["id"],
        h["name"],
        h["price"],
        h["category"])
      )

    end


    # we don't want to carry the original contents moving forward

    remove_instance_variable(:@contents)

  end

  def datafy
    tables = []

    instance_variables.each do |i|
      case i
      when :@users
        tables.push (UserTable.new(i, self.instance_variable_get(i)))
        binding.pry
      when :@items
        tables.push (ItemTable.new(i, self.instance_variable_get(i)))
      end
    end
    return tables

  end
end

class DataTable
  def initialize name, data_parser_data
    @data = []
    data_parser_data.each do |o|
      h = {}
      h["key"] = o.object_id
      o.instance_variables.each do |i|
        h[i.to_s.gsub(/^@/,"")] = o.instance_variable_get(i)
      end
      @data.push h
    end
  end
end

class ItemTable < DataTable
  def initialize name, data_parser_data
    super(name, data_parser_data)
  end
end

class UserTable < DataTable
  def initialize name, data_parser_data
    super(name, data_parser_data)
  end
end
