module TurboUtils
  def is_ti_manufactured? part
    part.manfr.name == 'Turbo International'
  end

  def get_ti_interchange interchanges
    interchanges.find { |i| i[:manufacturer] == "Turbo International" } if interchanges.class.name == "Array"
  end

  def get_ti_part_number part, interchanges
    if is_ti_manufactured? part
      part.manfr_part_num
    elsif (ti = get_ti_interchange(interchanges))
      ti[:part_number]
    end
  end

  def get_ti_part_id part, interchanges
    if is_ti_manufactured? part
      part.manfr_part_num
    elsif (ti = get_ti_interchange(interchanges))
      ti[:id]
    end
  end

  def get_oe_part_number part
    unless is_ti_manufactured? part
      part.manfr_part_num
    end
  end

  def rid_of_ti_interchange t, interchanges
    if t[:id] and t[:ti_id] and interchanges
      interchanges.delete_at(interchanges.index { |i| i[:id] == t[:ti_id] } || li.length)
      t[:interchanges] = interchanges
    end
    t
  end

  def prepare_manufacturers
    manfrs = Manfr.where not_external: true
    externals = []
    if manfrs
     externals = manfrs.map { |m| m.name }
    end
    ActiveRecord::Base.clear_active_connections!
    externals
  end
end