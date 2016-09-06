class ProductsCollection
  def initialize
    @product_cacher = AttributesCacher.new
    @price_cacher = PriceCacher.new
    @kit_matrix_cacher = KitMatrixCacher.new
    ActiveRecord::Base.logger = nil
  end

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
      puts "#{counter * 100} products to cache prices"
      @price_cacher.put ids
      counter += 1
    end
  end

  def cache_all_attributes since_id=0
    _process_products  since_id, @product_cacher
  end

  def cache_kit_matrix since_id=0
    _process_products  since_id, @kit_matrix_cacher
  end

  def cache_price_attribute since_id=0
    _process_products_in_batch since_id
  end


end