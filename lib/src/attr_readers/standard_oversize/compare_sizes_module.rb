module CompareSizes
  def _cmp_journal_bearing part, original_part
    unless original_part.maxOuterDiameter == part.maxOuterDiameter and
        original_part.minOuterDiameter == part.minOuterDiameter and
        original_part.maxInnerDiameter == part.maxInnerDiameter and
        original_part.minInnerDiameter == part.minInnerDiameter
      return {
          maxOuterDiameter: original_part.maxOuterDiameter.to_f - part.maxOuterDiameter.to_f,
          minOuterDiameter: original_part.minOuterDiameter.to_f - part.minOuterDiameter.to_f,
          minInnerDiameter: original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f,
          maxInnerDiameter: original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f
      }

    end
    false
  end

  def _cmp_journal_bearing_spacer part, original_part
    unless original_part.outerDiameterA == part.outerDiameterA and
        original_part.innerDiameterB == part.innerDiameterB
      return {
          outerDiameterA: original_part.outerDiameterA.to_f - part.outerDiameterA.to_f,
          innerDiameterB: original_part.innerDiameterB.to_f - part.innerDiameterB.to_f
      }

    end
    false
  end

  def compare_parts ids, original_part, part_type
    klass = Object.const_get(part_type)
    ids.map do |id|
      part = klass.find id
      method_name = "_cmp_" + part_type.underscore
      self.send(method_name, part, original_part)
    end
  end

end