require_relative "../test_helper"

class TestSalesNotesAttrsReader < MiniTest::Unit::TestCase

  def setup
    redis_host = get_redis_host
    @redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
  end

  def test_sales_note_getter
    getter = SalesNoteGetter.new @redis_cache
    attrs = getter.get_sales_note_attribute 16572
    assert_equal 2, attrs.size
    assert_equal 348, attrs[1][:id]
    assert_equal '03/15/2016', attrs[0][:create_date]
    assert_equal 'Left side of Audi twin turbo.', attrs[1][:comment]
  end

  def test_sales_note_setter
    setter = SalesNoteSetter.new @redis_cache
    setter.set_sales_note_attribute 16572
  end

  def test_batch_getter
    skus = [6673, 48509, 48544, 64073]
    getter = SalesNoteBatchGetter.new @redis_cache
    notes = getter.get_sales_note_attributes skus
    assert_equal 4, notes.size

  end


end