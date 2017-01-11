require_relative 'tools_helper'
@logger.info("Preload: Starting  preloading Gasket Kit ")
@products_collection = ProductsCollection.new
@products_collection.cache_gasket_kits
@logger.info("Preload: Ending preloading  Gasket Kit")