require "date"
require "json"

class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(json)
    @id = json["id"]
    @price_per_day = json["price_per_day"]
    @price_per_km = json["price_per_km"]
  end
end

class Rental
  attr_reader :id, :car_id, :days, :distance

  def initialize(json)
    @id = json["id"]
    @car_id = json["car_id"]
    @days = 1 + (Date.parse(json["end_date"]) - Date.parse(json["start_date"])).to_i
    @distance = json["distance"]
  end
end


def load_data(input_file)
  file = File.read(input_file)
  JSON.parse(file)
end

def write_result(output_file, result)
  File.write(output_file, JSON.pretty_generate(result) + "\n")
end

def compute_rental_price(rental, cars)
  car = cars.find { |car| car.id == rental.car_id }
  price_for_days = rental.days * car.price_per_day
  price_for_kms = rental.distance * car.price_per_km
  price_for_days + price_for_kms
end

def format_result(rentals, cars)
  {:rentals => rentals.map { |rental| {
                                :id => rental.id,
                                :price => compute_rental_price(rental, cars)
                              }}}
end

def solution()
  json = load_data('./data/input.json')
  cars = json["cars"].map { |car| Car.new(car) }
  rentals = json["rentals"].map { |rental| Rental.new(rental) }
  result = format_result(rentals, cars)
  write_result("./data/output.json", result)
end
