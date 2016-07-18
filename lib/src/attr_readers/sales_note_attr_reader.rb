class SalesNoteAttrReader
  def get_attribute sku
    sales_notes = []
    notes = Salesnotepart.where(part_id: sku)
    if notes.size > 0
      notes.each do |note|
        sales_note = Salesnote.find note.sales_note_id
        if sales_note.state=='published'
          sales_notes.push({:id => sales_note.id, :note => sales_note.state, :comment => sales_note.comment })
        end
      end
    end
    sales_notes
  end
end