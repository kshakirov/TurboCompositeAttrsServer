require_relative "test_helper"

class TestDecriptor < Minitest::Unit::TestCase
  def test_main
    decriptor = CustomerInfoDecypher.new
    decriptor.get_customer_group 'sVrXIqos994v0pkehHI28Q=='

  end

end