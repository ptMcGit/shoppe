require "faker"
require "pry"
require "json"

class TransactionGenerator
  def initialize user_count, item_count
    @users = make_users user_count
    @items = make_items item_count
  end

  def make_users count
    id = 0
    count.times.map do
      id += 1

      {
        id: id,
        name: Faker::Name.name,
        address: Faker::Address.street_address
      }
    end
  end

  def make_items count
    id = 0
    count.times.map do
      id += 1

      {
        id: id,
        name: Faker::Commerce.product_name,
        price: Faker::Number.decimal(2).to_f,
        category: Faker::Commerce.department(2)
      }
    end
  end

  def data
    {
      items: @items,
      users: @users
    }
  end

  # {
  #   timestamp:
  #   user_id:
  #   item_id:
  #   quantity:
  # }
  def make_transactions count
    count.times.map do
      {
        timestamp: Faker::Date.backward(30),
        user_id: @users.sample[:id],
        item_id: @items.sample[:id],
        quantity: rand(1 .. 10)
      }
    end
  end
end

t = TransactionGenerator.new 30, 20
File.write "./data/data.json", JSON.pretty_generate(t.data)
File.write "./data/transactions.json", JSON.pretty_generate(t.make_transactions 200)
