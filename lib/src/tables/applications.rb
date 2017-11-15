class TurboCarModelEngineYear < ActiveRecord::Base
self.table_name = "turbo_car_model_engine_year"
self.primary_key= "part_id"
  belongs_to :car_model_engine_year,  class_name: "CarModelEngineYear",
             foreign_key: "car_model_engine_year_id"
end

class CarModelEngineYear < ActiveRecord::Base
  self.table_name = "car_model_engine_year"
  self.primary_key = "id"
  belongs_to :car_model, class_name: "CarModel",
             foreign_key: "car_model_id"
  belongs_to :car_engine, -> { includes :car_fuel_type, class_name: "CarFuelType", foreign_key: "car_fuel_type_id" }, class_name: "CarEngine",
             foreign_key: "car_engine_id"
  belongs_to :car_year, class_name: "CarYear",
             foreign_key: "car_year_id"
end

class CarModel < ActiveRecord::Base
  self.table_name = "car_model"
  self.primary_key = "id"
  belongs_to :car_make, class_name: "CarMake",
             foreign_key: "car_make_id"
end

class CarEngine < ActiveRecord::Base
  self.table_name = "car_engine"
  self.primary_key = "id"
  belongs_to :car_fuel_type, class_name: "CarFuelType",
             foreign_key: "car_fuel_type_id"
end

class CarYear < ActiveRecord::Base
  self.table_name = "car_year"
  self.primary_key = "id"
end

class CarMake < ActiveRecord::Base
  self.table_name = "car_make"
  self.primary_key = "id"
end

class CarFuelType < ActiveRecord::Base
  self.table_name = "car_fuel_type"
  self.primary_key = "id"
end

