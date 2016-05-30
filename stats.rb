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

  raise NotAValidFile

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
parsers = []


(transaction_files + user_files).each do |file|
  begin
    p = determine_parse_method(file).new file
  rescue NotAValidFile => e
    next
  end
  p.parse!
  data_sets.push p
end

# gather up heterogenous data sets

# create databases from datasets

data_bases = {}
binding.pry
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
