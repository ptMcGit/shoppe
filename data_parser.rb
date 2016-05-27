require "json"

class DataParser

  attr_reader :path, :users, :items

  def initialize abs_filename

    @contents = JSON.parse File.read abs_filename
    @path = abs_filename
    @users = []
    @items = []

  end


  def parse!
    # @contents["users"].each do |user|
    #   @users.push(User.new user.values[0], user.values[1], user.values[2])
    # end

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
      #binding.pry
    end
    #binding.pry

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

  def get_uid username
    @users.select { |x| x.name == username }.map { |x| x.id }.join
#    Binding.pry
  end


end
