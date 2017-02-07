module CompareSizes


  def add_out_col hash
    hash.keys.map { |key|
      key_n = key.to_s + "_out"
      if hash[key] == 0
        hash[key_n.to_sym] = "STD"
      else
        hash[key_n] = sprintf("%0.04f", hash[key])
      end
    }
  end


  def query_part_attrs hash, part
    part = Part.find part.part_id
    add_out_col(hash)
    hash[:manufacturer] = part.manfr.name
    hash[:part_number] = part.manfr_part_num
    hash[:sku] = part.id
    hash
  end


  def prepare_response id, part
    query_part_attrs(id, part)
  end

  def prepare_sizes_hash_jb part, original_part
    {
        maxOuterDiameter: (original_part.maxOuterDiameter.to_f - part.maxOuterDiameter.to_f).round(4).abs,
        minOuterDiameter: (original_part.minOuterDiameter.to_f - part.minOuterDiameter.to_f).round(4).abs,
        minInnerDiameter: (original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f).round(4),
        maxInnerDiameter: (original_part.maxInnerDiameter.to_f - part.maxInnerDiameter.to_f).round(4)
    }
  end


  def prepare_sizes_hash_jbs part, original_part
    {
        outerDiameterA: original_part.outerDiameterA.to_f - part.outerDiameterA.to_f,
        innerDiameterB: original_part.innerDiameterB.to_f - part.innerDiameterB.to_f
    }
  end


  def _cmp_journal_bearing part, original_part
    unless original_part.maxOuterDiameter == part.maxOuterDiameter and
        original_part.minOuterDiameter == part.minOuterDiameter and
        original_part.maxInnerDiameter == part.maxInnerDiameter and
        original_part.minInnerDiameter == part.minInnerDiameter
      return prepare_response(prepare_sizes_hash_jb(part, original_part), part)

    end
    false
  end

  def _cmp_journal_bearing_spacer part, original_part
    unless original_part.outerDiameterA == part.outerDiameterA and
        original_part.innerDiameterB == part.innerDiameterB
      return prepare_response(prepare_sizes_hash_jbs(part, original_part), part_hash)

    end
    false
  end

  def compare_parts parts_ids, original_part, part_type
    klass = Object.const_get(part_type)
    parts_ids.map do |id|
      part = klass.find id
      method_name = "_cmp_" + part_type.underscore
      self.send(method_name, part, original_part)
    end
  end

  def do_orig_journal_bearing part, original_part
    {
        maxOuterDiameter: part.maxOuterDiameter.to_f.round(4),
        minOuterDiameter: part.minOuterDiameter.to_f.round(4),
        minInnerDiameter: part.minInnerDiameter.to_f.round(4),
        maxInnerDiameter: part.maxInnerDiameter.to_f.round(4),
        sku: original_part.id,
        part_number: original_part.manfr_part_num
    }
  end

  def do_orig_journal_bearing_spacer part, original_part
    {
        outerDiameterA: part.outerDiameterA.to_f,
        innerDiameterB: part.innerDiameterB.to_f,
        sku: original_part.id,
        part_number: original_part.manfr_part_num
    }
  end

  def map_interchanges sku
    interchanges = get_interchange_attribute(sku)
    interchanges.map { |i|
      i[:sku] = i[:id]
      i
    }

  end

  def do_original_part part, part_type, original_part
    method_name = "do_orig_" + part_type.underscore
    original_part_hash = self.send(method_name, part, original_part)
    original_part_hash[:interchanges] = map_interchanges(original_part.id)
    original_part_hash
  end

end