require "march_hare"
require_relative 'bom_syncer'
require_relative 'interchange_syncer'
ENV['RACK_ENV'] = 'development'
require_relative '../mappers_helper'
require_relative "interchange_worker"
require_relative "bom_worker"
require_relative "where_used_worker"