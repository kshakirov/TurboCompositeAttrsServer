
require 'arangorb'
ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
bom_databse = ArangoDatabase.new database: "Bom"
p bom_databse.collections
parts_collection  = bom_databse.collection("parts").retrieve
p parts_collection


10.times do |time|
  parts_collection.create_document document: {"id" => time}
end




