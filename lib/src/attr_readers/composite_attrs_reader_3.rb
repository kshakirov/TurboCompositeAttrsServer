class CompositAttrsReader
  def get_sales_notes sku
    @sales_note_reader.get_attribute sku
  end
end