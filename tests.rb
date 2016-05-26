require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require "./item"
require "./user"
require "./data_parser"
require "./transaction_parser"


class Minitest::Test
  # A little magic here, but this adds a `file_path` helper
  # function that is available in all of our test classes (how?)
  def file_path file_name
    File.expand_path "../tests/#{file_name}.json", __FILE__
  end
end


class ItemTests < Minitest::Test
  def socks
    Item.new 5, "Socks", 2.50, "Clothing"
  end

  def test_have_names
    assert_equal "Socks", socks.name
  end

  def test_have_ids
    assert_equal 5, socks.id
  end

  def test_have_price
    assert_equal 2.50, socks.price
  end

  def test_can_have_category
    assert_equal "Clothing", socks.category
  end

  def test_does_not_have_to_have_category
    log = Item.new 23, "Log", 9.99
    assert_equal nil, log.category
  end

  def test_does_have_to_have_price
    assert_raises ArgumentError do
      Item.new 1, "Socks"
    end
  end
end


class UserTests < Minitest::Test
  def test_have_attributes
    user = User.new 10, "Bilbo Baggins", "Bag End"
    assert_equal 10, user.id
    assert_equal "Bilbo Baggins", user.name
    assert_equal "Bag End", user.address
  end
end


class DataParserTests < Minitest::Test
  def test_can_parse_hobbits
    p = DataParser.new file_path("hobbitses")
    assert p.path.end_with? "tests/hobbitses.json"
    assert_equal [], p.users

    # recommendation: to parse the file, use something like
    # require "json"
    # JSON.parse(File.read path)
    p.parse!

    assert_equal 4, p.users.count
    assert p.users.sample.is_a? User
  end

  def test_can_parse_kittens
    p = DataParser.new file_path("kittens")

    p.parse!

    assert_equal 3, p.users.count
    assert_equal 2, p.items.count
    assert p.items.sample.is_a? Item
  end
end


class TransactionParserTests < Minitest::Test
  def test_can_parse_monday
    p = TransactionParser.new file_path("monday")
    p.parse!

    assert_equal 5, p.transaction_count
  end

  def test_can_parse_tuesday
    p = TransactionParser.new file_path("tuesday")
    p.parse!

    assert_equal 15, p.transaction_count
  end

  # Now it's your turn ... what other tests might be
  # helpful here? Feel free to re-use the existing test
  # files or to write your own
end
