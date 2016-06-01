# Shopnatra

require "pry"

require "./item"
require "./user"
require "./transaction"

require "./data_parser"
require "./transaction_parser"
require "./database"

require "httparty"
require "./creds"

Url = "https://shopnatra.herokuapp.com"

def get_data
  HTTParty.get(
    Url + "/data" + "?password=" + Pass
  )
end

def get_transactions yyyy_mm_dd
  HTTParty.get(
    Url + "/transactions/" + yyyy_mm_dd + "?password=" + Pass
  )
end

def is_a_valid_file? file
  File.readable?(file)
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

# get, store data

data_dir = "./shopnatra_data/"

f = File.open(data_dir + "data.json", "w")
f.write(get_data.to_json)
f.close

f = File.open(data_dir + "transactions.json", "w")
f.write(get_transactions("2016-05-30").to_json)
f.close

# Parse data, and create tables

data_sets = []

shopnatra_files = [ data_dir + "data.json", data_dir + "transactions.json" ]

shopnatra_files.each do |file|
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

# data_sets.each do |h|
#   f = File.open(data_dir + h[:name],"w")
#   f.write(h[:source])
#   f.close
# end
# exit

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

c_watch_record = shoppe.unique_record items, "name", "Incredible Cotton Watch"
c_watch_id = c_watch_record["id"]

c_watch_purchases = shoppe.filter_by_value(transaction, "item_id", c_watch_id)

c_watch_total = shoppe.sum_column c_watch_purchases, "quantity"

puts "2. We sold #{c_watch_total} Incredible Cotton Watches."

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

items_cats_extended = shoppe.sum_by(items_extended, "category", "ext")

single_cat = items_cats_extended.max_by { |k,v| v}

answer_formatted = "$" + ('%.2f' % single_cat["total"].round(2)).to_s.reverse.gsub(/\d\d\d/, '\&,').reverse

print "5a. The highest grossing single category was #{single_cat["category"]} at #{answer_formatted}.\n"

g = Hash.new(0)

items_cats_extended.each do |k|
  cats = k["name"].gsub(/&/,"").split(" ")
  cats.each do |cat|
    g[cat] += k["total"]
  end
end

approx_cat = g.max_by { |k,v| v}

answer_formatted = "$" + ('%.2f' % approx_cat[1].round(2)).to_s.reverse.gsub(/\d\d\d/, '\&,').reverse

print "5b. Unmixing the categories suggests that #{approx_cat[0]} may be the highest grossing category at #{answer_formatted}.\n"
