class PriceAuditUpdater
  private
  def _update id
    audit = PartAudit.new
    audit.part_id = id
    audit.action = 'update'
    audit.save
    id
  end


  def update_ti_parts ids
    ids.map { |id| _update(id) }
  end

  def update_interchanged ids
    ids.map { |id|
      ints = @interchange_getter.get_cached_interchange(id)
          ints.map { |int| _update(int[:id] )} if ints
    }
  end

  def _update_audit_table ids
    result  = update_ti_parts(ids ) + update_interchanged(ids)
    result.compact!
    result.flatten
  end

  public

  def initialize
    @interchange_getter = InterchangeGetter.new
  end


  def update_audit_table ids
    if ids and ids.class.name == "Array"
       _update_audit_table(ids)
    end
  end
end