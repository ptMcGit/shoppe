require "pry"

require "./item"
require "./user"
require "./parser"
require "./data_parser"
require "./transaction_id"
require "./transaction_parser"
require "./database"
require "./database_mgr"
require "./user_database"
require "./item_database"
require "./transaction_database"

def is_a_valid_file? file
  File.readable?(file)
end

def object_to_prototype object
  return_h = {}
  object.instance_variables.each {|attr| return_h[attr.to_s.delete("@")] = object.instance_variables_get(attr).class }
  return_h
  binding.pry
end

def determine_parse_method abs_filename
  h = JSON.parse File.read abs_filename

  begin
    if is_a_transaction_file? h
      return TransactionParser
    end
  rescue NoMethodError => e
  end

  begin
    if is_a_data_file? h
      return DataParser
    end
  rescue NoMethodError => e
  end

  raise ArgumentError, "Filename is not valid."

end

data_sets = []

ARGV.each do |file|
  begin
    unless is_a_valid_file? file
      raise ArgumentError, "Filename is not valid."
    end
    p = determine_parse_method(file).new file
  rescue ArgumentError, "Filename is not valid" => e
    next
  end
  p.parse!
  data_sets.push p
end

# gather up heterogenous data sets

# create databases from datasets

data_bases = {}
data_sets.each do |object|
  object.instance_variables.each do |i_var|
    data = object.instance_variable_get(i_var)
    if data_bases.keys.include? i_var
      data_bases[i_var].add_data data
    else
      case i_var
      when :@users
        data_bases[i_var] = UserDatabase.new data
      when :@items
        data_bases[i_var] = ItemDatabase.new data
      when :@transaction
        data_bases[i_var] = TransactionDatabase.new data
      else
        data_bases[i_var] = DataBase.new data
      end
    end
  end
end

data_sets.clear
mgr = DataBaseMgr.new data_bases
db = mgr.current_db

# access database

binding.pry

db = select_db data_bases[:@transaction]
table = data_bases[:@transaction].user_order_by_amount

binding.pry
user_order_amount_descending = Hash.new(0)

db.each do |transaction|
  user_order_amount_descending[transaction["user_id"]] += transaction["quantity"]
end

sorted = user_order_amount_descending.sort_by { |key, value| value }.reverse!
#binding.pry
#inter = user_order_amount_descending.sort { |key, value| key }.reverse!
#binding.pry
#data_bases[:@transaction].instance_variable_get(:@data)[0]

table = []
#count = 1

sorted.each do | uid, total |
  table << {"user_id"=>uid,"total"=>total}
#  count += 1
end
binding.pry
answer = user_order_amount_descending.map { |key, value| {"user_id"=>key, "total"=>value}}

inter = user_order_amount_descending.sort_by { |key, value| value }.reverse.map { |x,y| {x=>y}}
highest = user_order_amount_descending.sort_by { |id, qty| qty }.reverse.first

mgr.current_db.data.select { |o| o.id == 52 }[0].name
mgr.current_db.data.max_by { |h| h["quantity"] }
mgr.current_db.data.select { |o| o["item_id"] == 5 }.map { |o| o["quantity"] }.reduce :+
  #json_parsed_file.pop json_parsed_file.count - 1
binding.pry
mgr.current_db.data.select { |o| o.category == "Household Goods" }.map { |o| o.id }

mgr.current_db.data.map { |h| x.select { |r| r.id == h["item_id"] } }

mgr.current_db.data.map { |h| [h["quantity"], x.select { |r| r.id == h["item_id"]}.map {|i| i.price }] }.map {|y| y.flatten}.map {|j| j.reduce :* }.reduce :+

#   table = mgr.current_db.select ...
#        table2 = mgr.current_db.select ...

# join table, "id", table2, "item_id",
# extend table "id" "qty"
# sum table "id"
