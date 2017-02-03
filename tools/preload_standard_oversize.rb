require_relative 'tools_helper'
@logger.info("Preload: Starting  preloading Standard Oversize ")
@products_collection = ProductsCollection.new
@products_collection.cache_std_oversize
@logger.info("Preload: Ending preloading Standard Oversize")