class DataBaseMgr

  attr_reader :current_db

  def initialize databases
    @databases = databases
    @current_db = @databases[@databases.keys.first]
  end

  def select_db database_name
    @current_db = @databases[database_name]
  end

end

#   data_bases[:@users].instance_variable_get(:@data)
