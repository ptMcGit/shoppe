class ItemDatabase < DataBase
  attr_reader :data
  def initialize data
    @data = ensure_array(data)
  end
end
