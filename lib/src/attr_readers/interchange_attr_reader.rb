class InterchangeAttrReader
  def get_attribute id
    response = []
    ints = Vint.where(part_id: id)
    ints.each do |int|
      response.push({:id => int.i_part_id, :manufacturer => int.i_manufacturer})
    end
    response
  end
end