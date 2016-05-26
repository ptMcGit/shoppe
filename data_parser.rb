require "json"

class DataParser

  attr_reader :path, :users, :items

  def initialize abs_filename

    @contents = JSON.parse File.read abs_filename
    @path = abs_filename
    @users = []
    @items = []
    #binding.pry

  end

  def parse!
    @contents["users"].each do |user|
      @users.push(User.new user.values[0], user.values[1], user.values[2])
    end
    #binding.pry
    @contents["items"].each do |item|
      @items.push(Item.new item.values[0], item.values[1], item.values[2], item.values[3])

    end
  end

end
