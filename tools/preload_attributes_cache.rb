require_relative 'tools_helper'

@logger.info("Preload: Starting  preloading attributes ")
@products_collection = ProductsCollection.new
since = ARGV[0].to_i || 0
@products_collection.cache_all_attributes since
@logger.info("Preload: Ending preloading  attributes")