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
    @contents["users"].each do |user|
      @users.push(User.new user.values[0], user.values[1], user.values[2])
    end

    binding.pry

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

end
