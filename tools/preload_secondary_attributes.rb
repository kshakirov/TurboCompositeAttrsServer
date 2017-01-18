require_relative 'tools_helper'

@logger.info("Preload: Starting  preloading  secondary attributes ")
@products_collection = ProductsCollection.new
since = ARGV[0].to_i || 0
@products_collection.cache_secondary_attrs since
@logger.info("Preload: Ending preloading  secondary attributes")