require_relative 'tools_helper'

@products_collection = ProductsCollection.new
since = ARGV[0].to_i || 0
@products_collection.cache_price_attribute since