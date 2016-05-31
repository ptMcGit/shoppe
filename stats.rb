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
binding.pry

#mgr = DataBaseMgr.new data_bases

# First question

## user table
mgr.select_db :@users
user_table = Hash[mgr.current_db.data.map { |h| [h.id, h.name] }]

mgr.select_db :@transaction
db = mgr.current_db.data
u = Hash.new(0)
db.each do |h|
  u[h["user_id"]] += h["quantity"]
end

answer = Hash[u.map { |k,v| [user_table[k], v] }].max_by { |n,q| q }
puts "1. The user that made the most orders was #{answer[0]} with #{answer[1]} orders."

# Second question

mgr.select_db :@items
db = mgr.current_db.data
item_id = db.select { |o| o.name == "Ergonomic Rubber Lamp" }[0].id

h = Hash.new(0)
mgr.select_db :@transaction
db = mgr.current_db.data
answer = db.select { |o| o["item_id"] == item_id }.map { |o| o["quantity"] }.reduce :+


puts "2. We sold #{answer} Ergonomic Rubber Lamps."

# Question 3

mgr.select_db :@items
db = mgr.current_db.data

tools_cat = db.select { |o| o.category == "Tools" }.map { |o| o.id }
tc_cat = db.select { |o| o.category == "Tools & Computers" }.map { |o| o.id }

h = Hash.new(0)
mgr.select_db :@transaction
db = mgr.current_db.data

answer = db.select { |o| tools_cat.include? o["item_id"] }.map {|o| o["quantity"] }.reduce :+

answer2 = db.select { |o| tc_cat.include? o["item_id"] }.map {|o| o["quantity"] }.reduce :+

puts "3. We sold #{answer} items from the Tools category and #{answer2} items from the Tools & Computers category"

# Question 4

mgr.select_db :@transaction
db = mgr.current_db.data

mgr.select_db :@items
db2 = mgr.current_db.data

answer = db.map { |h| [h["quantity"], db2.select { |r| r.id == h["item_id"]}.map {|i| i.price }] }.map {|y| y.flatten}.map {|j| j.reduce :* }.reduce :+
answer_formatted = "$" + answer.round(2).to_s.reverse.gsub(/\d\d\d/, '\&,').reverse

puts "4. Our total revenue was #{answer_formatted}."

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
