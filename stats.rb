require "pry"

require "./item"
require "./user"
require "./transaction"

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

# Parse data, and create tables

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
  data_sets.push p.datafy
end

# create databases from datasets

shoppe = DataBase.new data_sets
data_sets.clear

users = shoppe.tables["users"]
items = shoppe.tables["items"]
transaction = shoppe.tables["transaction"]

# First question

u_and_t = shoppe.add_table "u_and_t", shoppe.join_tables(users, "id", transaction, "user_id")

volume_buyers = shoppe.add_table "volume_buyers", shoppe.sum_by(u_and_t, "name", "quantity")

highest_volume = shoppe.max_record volume_buyers, "total"

puts "1. The user that made the most orders was #{highest_volume["name"]} with #{highest_volume["total"]} orders."

# Second question

ergo_lamp_record = shoppe.unique_record items, "name", "Ergonomic Rubber Lamp"
ergo_lamp_id = ergo_lamp_record["id"]

ergo_lamp_purchases = shoppe.filter_by_value(transaction, "item_id", ergo_lamp_id)

ergo_lamp_total = shoppe.sum_column ergo_lamp_purchases, "quantity"

puts "2. We sold #{ergo_lamp_total} Ergonomic Rubber Lamps."

# Question 3

tools_cat = shoppe.filter_by_value items, "category", "Tools"
tools_cat_ids = shoppe.get_values tools_cat, "id"
tool_purchases = shoppe.filter_by_value transaction, "item_id", tools_cat_ids
tool_totals = shoppe.sum_column tool_purchases, "quantity"


puts "3. We sold #{tool_totals} items from the Tools category."

# Question 4

items_with_price = shoppe.join_tables items, "id", transaction, "item_id"
items_extended = shoppe.extend_table items_with_price, "quantity", "price"
items_summed = shoppe.sum_column items_extended, "ext"

answer_formatted = "$" + items_summed.round(2).to_s.reverse.gsub(/\d\d\d/, '\&,').reverse

puts "4. Our total revenue was #{answer_formatted}."

binding.pry

mgr.select_db :@transaction
db = mgr.current_db.data

mgr.select_db :@items
db2 = mgr.current_db.data

qty_price_cat = db.map { |h| [h["quantity"], db2.select { |r| r.id == h["item_id"]}.map {|i| [i.price, i.category]}] }.map { |x| x.flatten }

h = Hash.new(0)

qty_price_cat.each do |x,y,z|
  h[z] += x * y
end

single_cat = h.max_by { |k,v| v}

answer_formatted = "$" + ('%.2f' % single_cat[1].round(2)).to_s.reverse.gsub(/\d\d\d/, '\&,').reverse

print "5a. The highest grossing single category was #{single_cat[0]} at #{answer_formatted}.\n"

g = Hash.new(0)

h.each do |k,v|
  cats = k.gsub(/&/,"").split(" ")
  cats.each do |cat|
    g[cat] += v
  end
end

approx_cat = g.max_by { |k,v| v}

answer_formatted = "$" + ('%.2f' % approx_cat[1].round(2)).to_s.reverse.gsub(/\d\d\d/, '\&,').reverse

print "5b. Unmixing the categories suggests that #{approx_cat[0]} may be the highest grossing category at #{answer_formatted}.\n"
