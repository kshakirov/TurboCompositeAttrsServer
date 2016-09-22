class SalesNoteAttrReader

  def format_date date
    date.strftime("%m/%d/%Y")
  end

  def build_sales_note_attribute note
    sales_note = Salesnote.find note.sales_note_id
    if sales_note.state=='published'
      {:id => sales_note.id,
       :note => sales_note.state,
       :comment => sales_note.comment,
       :create_date => format_date(sales_note.create_date)}
    end
  end

  def has_notes? notes
    notes.size > 0
  end

  def get_attribute sku
    sales_notes = []
    notes = Salesnotepart.where(part_id: sku)
    if has_notes? notes
      notes.each do |note|
        unless (note = build_sales_note_attribute(note)).nil?
          sales_notes.push note
        end
      end
    end
    sales_notes
  end
end