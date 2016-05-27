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
    end

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

    # we don't want to carry the original contents moving forward

    @contents = []

  end
end
