class ProductsCollection
  def initialize
    @product_cacher = AttributesCacher.new
    @price_cacher = PriceCacher.new
    @kit_matrix_cacher = KitMatrixCacher.new
    @secondary_attributes_cacher = SecondaryAttributesCacher.new
    @gasket_kit_cacher = GasketKitCacher.new
    @std_oversize_cacher = StandardOversizeCacher.new

    ActiveRecord::Base.logger = nil
  end

  private
  def _process_products since_id, cacher
    Part.find_each(batch_size: 100) do |p|
      if since_id and since_id < p.id
        puts "Adding Product [#{p.id}], name [#{p.manfr_part_num}]"
        cacher.put p.id
      end
    end
  end

  def _process_products_in_batch since_id
    counter = 1
    Part.find_in_batches(start: since_id, batch_size: 100) do |group|
      ids = []
      group.each { |part| ids.push part.id }
      puts "#{counter * 100} products to cache prices, starting id => #{group.first.id}"
      @price_cacher.put ids
      counter += 1
    end
  end

  def _process_gaskets cacher
    GasketKit.all.each do |gk|
      puts "Adding Gasket Kit  [#{gk.part_id}]"
      cacher.put gk.id
    end
  end


  def _process_std_oversize cacher
    JournalBearing.all.each do |std|
      puts "Adding Std Oversize  [#{std.part_id}]"
      cacher.put std.id
    end
    JournalBearingSpacer.all.each do |std|
      puts "Adding Std Oversize  [#{std.part_id}]"
      cacher.put std.id
    end
  end

  public
  def cache_gasket_kits
    _process_gaskets(@gasket_kit_cacher)
  end

  def cache_all_attributes since_id
    _process_products since_id, @product_cacher
  end

  def cache_kit_matrix since_id=0
    _process_products since_id, @kit_matrix_cacher
  end

  def cache_price_attribute since_id=0
    _process_products_in_batch since_id
  end

  def cache_one_attribute since_id=0, cacher_instance
    _process_products since_id, cacher_instance
  end

  def cache_secondary_attrs since_id=0
    _process_products since_id, @secondary_attributes_cacher
  end

  def cache_std_oversize
    _process_std_oversize(@std_oversize_cacher)
  end

end