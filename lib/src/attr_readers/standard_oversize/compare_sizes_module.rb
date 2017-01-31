module CompareSizes


  def query_part_attrs hash, part_hash
    part = Part.find  part_hash[:id]
    hash[:manufacturer] = part.manfr.name
    hash[:part_number] =  part.manfr_part_num
    hash[:sku] = part_hash[:id]
  end

  def add_properties hash, part_hash
    hash[:manufacturer] = part_hash[:manufacturer]
    hash[:part_number] = part_hash[:part_number]
    hash[:sku] = part_hash[:id]
  end

  def prepare_response hash, part_hash
    if part_hash.key? :manufacturer
      add_properties(hash, part_hash)
    else
       query_part_attrs(hash, part_hash)
    end
    hash
  end

  def prepare_sizes_hash_jb part, original_part
    {
        maxOuterDiameter: original_part.maxOuterDiameter.to_f - part.maxOuterDiameter.to_f,
        minOuterDiameter: original_part.minOuterDiameter.to_f - part.minOuterDiameter.to_f,
        minInnerDiameter: original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f,
        maxInnerDiameter: original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f
    }
  end


  def prepare_sizes_hash_jbs part, original_part
    {
        outerDiameterA: original_part.outerDiameterA.to_f - part.outerDiameterA.to_f,
        innerDiameterB: original_part.innerDiameterB.to_f - part.innerDiameterB.to_f
    }
  end


  def _cmp_journal_bearing part, original_part, part_hash
    unless original_part.maxOuterDiameter == part.maxOuterDiameter and
        original_part.minOuterDiameter == part.minOuterDiameter and
        original_part.maxInnerDiameter == part.maxInnerDiameter and
        original_part.minInnerDiameter == part.minInnerDiameter
      return prepare_response(prepare_sizes_hash_jb(part, original_part), part_hash)

    end
    false
  end

  def _cmp_journal_bearing_spacer part, original_part, part_hash
    unless original_part.outerDiameterA == part.outerDiameterA and
        original_part.innerDiameterB == part.innerDiameterB
      return prepare_response(prepare_sizes_hash_jbs(part, original_part), part_hash)

    end
    false
  end

  def compare_parts parts_hashes, original_part, part_type
    klass = Object.const_get(part_type)
    parts_hashes.map do |part_hash|
      part = klass.find part_hash[:id]
      method_name = "_cmp_" + part_type.underscore
      self.send(method_name, part, original_part, part_hash)
    end
  end

end