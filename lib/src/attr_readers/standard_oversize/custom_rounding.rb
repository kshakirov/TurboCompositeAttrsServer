module CompareSizes

  def _delta_jb delta
     times = delta / 0.005
     times = times.round
      0.005  * times
  end

  def _delta_pr delta
    times = delta / 0.010
    times = times.round
    0.010  * times
  end

  def custom_round_journal_bearing deltas
    deltas.each do |key, delta|
      if delta.class.name == 'Float'
        deltas[key] = _delta_jb(delta)
      end
    end
  end

  def custom_round_piston_ring deltas
    deltas.each do |key, delta|
      if delta.class.name == 'Float'
        deltas[key] = _delta_pr(delta)
      end
    end
  end

end