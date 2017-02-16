require_relative "tools_helper"
interchange_reader = InterchangeGetter.new
extended_list_file = File.new("price_changes_extended.dat", "w")
File.open("price_changes.dat", 'r') do |file|
  file.readlines.each do |line|
    puts line
    extended_list_file.puts line
    interchanges = interchange_reader.get_cached_interchange line.to_i
    interchanges.each{|i| extended_list_file.puts i[:id]} if interchanges
  end
end
extended_list_file.close