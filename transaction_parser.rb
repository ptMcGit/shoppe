class TransactionParser

  def initialize abs_filename
    @contents = JSON.parse File.read abs_filename
    @path = [abs_filename]
    @transaction = []
  end

  def parse!
    @contents.each do |transaction|
      transaction["unique_id"] = TransactionID.new
      @transaction.push transaction
    end

    # remove original data from the object

    remove_instance_variable(:@contents)
  end
end
