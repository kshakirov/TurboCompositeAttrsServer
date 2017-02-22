module CompareSizes

  def _delta_jb delta
    if delta.between?(-0.0075, -0.0025)
      -0.005
    elsif delta.between?(-0.0025, 0.0025)
      0
    elsif delta.between?(0.0025, 0.0075)
      0.005
    elsif delta.between?(0.0075, 0.0125)
      0.010
    else
      delta
    end
  end

  def custom_round_journal_bearing deltas
    deltas.each do |key, delta|
      if delta.class.name == 'Float'
        deltas[key] = _delta_jb(delta)
      end
    end
  end
end