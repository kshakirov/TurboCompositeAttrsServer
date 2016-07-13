require_relative "test_helper"

class TestDecriptor < Minitest::Unit::TestCase
  def test_main
    decriptor = CustomerInfoDecypher.new
    result = decriptor.get_customer_group 'sVrXIqos994v0pkehHI28Q=='
    assert_equal '11', result
  end

  def test_wrong
    decriptor = CustomerInfoDecypher.new
    result = decriptor.get_customer_group '123'
    assert_equal 'no stats', result
  end

end