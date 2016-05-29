require "pry"

require "./item"
require "./user"
require "./data_parser"
require "./transaction_id"
require "./transaction_parser"
require "./database"
require "./database_mgr"
require "./user_database"
require "./item_database"
require "./transaction_database"
require "./parser"

def object_to_prototype object
  return_h = {}
  object.instance_variables.each {|attr| return_h[attr.to_s.delete("@")] = object.instance_variables_get(attr).class }
  return_h
  binding.pry
end

#def is_transaction?

def determine_parse_method abs_filename         # this is really hard to determine
  contents = JSON.parse File.read abs_filename
  binding.pry
  if is_a_transaction_file? contents
    return TransactionParser.new abs_filename
    #binding.pry
  #elsif is_a_data_file? contents
  #  return DataParser.new contents
  #elsif is_an_user_file?
  #elsif is_an_items_file?
  else
    return DataParser.new abs_filename
    #binding.pry
  end
end


user_files = [
  "/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/kittens.json",
"/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/hobbitses.json"
]

transaction_files = [
  "/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/monday.json",
"/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/tuesday.json"
]

#exit

data_sets = []

#(transaction_files + user_files).each do |file|
#  data_sets.push(determine_parse_method(file).parse!)
  #puts TransactionParser::bob
  #p.push Parser.new file
#end

#STATS should be in a CLASS!
#DataBaseMgr should be stats? Probably.

#select_db :users    # should be this easy
#=> modifies @selected_db

#table = select_records_meeting_criteria

# gather up heterogenous data sets

user_files.each do |file|
  p = DataParser.new file
  p.parse!
  data_sets.push p
end

transaction_files.each do |file|
  p = TransactionParser.new file
  p.parse!
  data_sets.push p
end

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

    # if data_bases.keys.include? i_var
    #   # add to db
    #   data_bases[i_var].add_data data
    # else
    #   # create db
    #     data_bases[i_var] = DataBase.new data
      #########data_bases[i_var] = DataBase.new i_var.to_s.gsub(/@/,""), object.instance_variable_get(i_var)
    # end
  end
end

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

binding.pry
