class User

  attr_reader :id, :name, :address

  def initialize id, name, address
    @id = id
    @name = name
    @address = address
  end

end

class UserDataSet

  attr_reader :user_data

  def initialize data_array
    @user_data = data_array
  end

  # def get_username uid
  #   user_data.select { |x| x.id == uid }.map { |x| x.name }.join
  # end

  # def get_uid username
  #   user_data.select { |x| x.name == username }.map { |x| x.id }.join
  #   #    Binding.pry
  # end

end
