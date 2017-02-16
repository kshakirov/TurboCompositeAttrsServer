require './composite_attr_server.rb'

#\ -w -p 4571
run Rack::URLMap.new({
                         '/' => Public
                     })