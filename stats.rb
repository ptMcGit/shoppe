
require "pry"

require "./item"
require "./user"
require "./data_parser"
require "./transaction"
require "./transaction_parser"
#require "./tests"


class DataBase
  def initialize data
    #@name = name
    @data = data
  end

  def add_data data
    @data.concat data
  end
end


#user_d = UserData.new(DataParser.new



user_files = [
  "/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/kittens.json",
"/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/hobbitses.json"
]

transaction_files = [
  "/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/monday.json",
"/Users/gazelle/Desktop/Iron_Yard_Ruby/ruby_stuff/shoppe/tests/tuesday.json"
]


data_sets = []

user_files.each do |file|
  p = DataParser.new file
  #binding.pry
  p.parse!
  data_sets.push p
end

transaction_files.each do |file|
  p = TransactionParser.new file
  p.parse!
  data_sets.push p
end

data_bases = {}

data_sets.each do |object|
  object.instance_variables.each do |i_var|
    #binding.pry
    if data_bases.keys.include? i_var
#      binding.pry# do not create a new db
      data_bases[i_var].add_data object.instance_variable_get(i_var)
    else
      # create db
      data_bases[i_var] = DataBase.new object.instance_variable_get(i_var)
      #data_bases[i_var] = DataBase.new i_var.to_s.gsub(/@/,""), object.instance_variable_get(i_var)

    end
  end
end

binding.pry

class Stats



  def initialize data_array
    @data = data_array
  end
  def merge_data! primary, secondary, *others
    binding.pry
  end
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


#  def user_who_make_most_orders
#    binding.pry
#  end
