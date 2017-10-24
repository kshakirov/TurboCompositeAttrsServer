class ManufacturerSingleton
  include Singleton
  def initialize
    @manufacturers = Manfr.all.map{|pt| [pt.id, pt.name]}
    @manufacturers = @manufacturers.to_h
  end

  def get_manufacturer_name id
    @manufacturers[id]
  end

end