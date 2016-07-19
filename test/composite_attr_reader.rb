require_relative "test_helper"

class TestCompositeAttrsReader < MiniTest::Unit::TestCase
  def test_where_used
    # @stdreader = CompositAttrsReader.new
    # attrs = @stdreader.get_where_used_attribute 49639, 'sVrXIqos994v0pkehHI28Q=='
    # assert_equal  'Cartridge', attrs['4742']['partType']
    # assert_equal  'CHRA, CT10', attrs['6673']['description']
    # assert_equal  117.8, attrs['6673'][:prices]

  end
  # def test_bom
  #   @stdreader = CompositAttrsReader.new
  #    attrs = @stdreader.get_bom_attribute 6392, 'sVrXIqos994v0pkehHI28Q=='
  #    p attrs
  # end
  #
  #
  # def test_interchanges
  #   @stdreader = CompositAttrsReader.new
  #   attrs = @stdreader.get_interchange_attribute 6392, 'sVrXIqos994v0pkehHI28Q=='
  #   p attrs
  #   assert_equal 2, attrs.size
  #   assert attrs[0].key? :description
  # end
  #
  # def test_kit_matrix
  #   @stdreader = CompositAttrsReader.new
  #   attrs = @stdreader.get_kit_matrix 62857
  #   p attrs
  #   assert_equal 2, attrs.size
  #   assert attrs[0].key? :description
  # end
  #
  #
  # def test_service_kits
  #   @stdreader = CompositAttrsReader.new
  #   attrs = @stdreader.get_service_kits 10513, 'sVrXIqos994v0pkehHI28Q=='
  #   p attrs
  #   assert_equal 14, attrs.size
  #   assert attrs[0].key? :description
  # end


  # def test_sales_notes
  #   @stdreader = CompositAttrsReader.new
  #   attrs = @stdreader.get_sales_notes 6392
  #   p attrs
  # end


  def test_major_components
    @stdreader = CompositAttrsReader.new
    attrs = @stdreader.get_major_component 10513,'sVrXIqos994v0pkehHI28Q=='
    p attrs
    assert_equal 18, attrs.size
  end


end