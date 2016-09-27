require_relative 'tools_helper'
@logger.info("Preload: Starting  preloading Kit matrixes ")
@products_collection = ProductsCollection.new
@products_collection.cache_kit_matrix
@logger.info("Preload: Ending preloading  Kit matrixes")