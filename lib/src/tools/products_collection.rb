class ProductsCollection
  def initialize
    @product_cache = ProductCache.new
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
  end
  def _add_products_to_collection since_id=nil

    Part.find_each(batch_size: 10) do |p|
      if since_id and since_id < p.id
        puts "Adding Product [#{p.id}], name [#{p.manfr_part_num}]"
        @product_cache.get_cached_attributes p.id
      end
    end
  end


end