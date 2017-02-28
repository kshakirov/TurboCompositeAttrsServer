module CustomSort
  def _sort_journal_bearing table
    table.sort_by do |row|
      [row[:maxOuterDiameter], row[:maxInnerDiameter], row[:part_number]]
    end
  end

  def _sort_piston_ring table
    table  = table.sort_by do |row|
      [row[:installedDiameterA], row[:gapBInstalledDiameter], row[:part_number]]
    end
    table.reverse
  end

  def custom_sort part_type, table
    method_name = "_sort_" + part_type.underscore
    self.send(method_name, table)
  end
end