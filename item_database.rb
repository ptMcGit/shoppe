class ItemDatabase < DataBase
  attr_reader :data
  def initialize data
    super(data)
  end
end
