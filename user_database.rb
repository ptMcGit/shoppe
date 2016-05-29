class UserDatabase < DataBase
  attr_reader :data
  def initialize data
    super(data)
  end

  # def user_order_by_amount
  #   db = self.instance_variable_get(:@data)
  #   user_order_amount_descending = Hash.new(0)

  #   db.each do |transaction|
  #     user_order_amount_descending[transaction["user_id"]] += transaction["quantity"]
  #   end
  #   sorted = user_order_amount_descending.sort_by { |key, value| value }.reverse!
  #   #binding.pry
  #   #inter = user_order_amount_descending.sort { |key, value| key }.reverse!
  #   #binding.pry
  #   #data_bases[:@transaction].instance_variable_get(:@data)[0]

  #   table = []
  #   #count = 1


  #   sorted.each do | uid, total |
  #     table << {"user_id"=>uid,"total"=>total}
  #     #  count += 1
  #   end
  #   table
  # end

end
