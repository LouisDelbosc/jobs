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

class Commission
  attr_reader :insurrance, :assistance, :drivy

  def initialize(price, days)
    total = (price * 0.3).round
    @insurrance = total / 2
    @assistance = days * 100
    @drivy = total - insurrance - assistance
  end
end

# ================ Level 1 ================

def load_data(input_file)
  file = File.read(input_file)
  JSON.parse(file)
end

def write_result(output_file, result)
  File.write(output_file, JSON.pretty_generate(result) + "\n")
end

def compute_rental_price_level1(rental, cars)
  car = cars.find { |car| car.id == rental.car_id }
  price_for_days = rental.days * car.price_per_day
  price_for_kms = rental.distance * car.price_per_km
  price_for_days + price_for_kms
end

def format_result(rentals, cars)
  {:rentals => rentals.map { |rental| {
                                :id => rental.id,
                                :price => compute_rental_price_level1(rental, cars)
                              }}}
end

def solution_level1()
  json = load_data('../level1/data/input.json')
  cars = json["cars"].map { |car| Car.new(car) }
  rentals = json["rentals"].map { |rental| Rental.new(rental) }
  result = format_result(rentals, cars)
  write_result("output_level1.json", result)
end

# ================ Level 2 ================

def car_price_for_rental_day(daily_price, day)
  if day <= 1
    daily_price
  elsif day <= 4
    daily_price * 0.9
  elsif day <= 10
    daily_price * 0.7
  else
    daily_price * 0.5
  end
end

def compute_day_price(price, days)
  arr = Array.new(days, price)
  daily_price = arr.map.with_index { |price, index| car_price_for_rental_day(price, index + 1) }
  daily_price.reduce(0, :+).round
end

def compute_rental_price_level2(rental, cars)
  car = cars.find { |car| car.id == rental.car_id }
  price_for_days = compute_day_price(car.price_per_day, rental.days)
  price_for_kms = rental.distance * car.price_per_km
  price_for_days + price_for_kms
end

def solution_level2()
  json = load_data('../level2/data/input.json')
  cars = json["cars"].map { |car| Car.new(car) }
  rentals = json["rentals"].map { |rental| Rental.new(rental) }
  result = {:rentals => rentals.map { |rental| {
                                        :id => rental.id,
                                        :price => compute_rental_price_level2(rental, cars)
                                      }}}
  write_result("output_level2.json", result)
end

# ================ Level 3 ================

def format_commission(commission)
  {
    :insurance_fee => commission.insurrance,
    :assistance_fee => commission.assistance,
    :drivy_fee => commission.drivy,
  }
end

def solution_level3()
  json = load_data('../level3/data/input.json')
  cars = json["cars"].map { |car| Car.new(car) }
  rentals = json["rentals"].map { |rental| Rental.new(rental) }
  result = {:rentals => rentals.map { |rental|
              price = compute_rental_price_level2(rental, cars)
              {
                :id => rental.id,
                :price => price,
                :commission => format_commission(Commission.new(price, rental.days))
              }}}
  write_result("output_level3.json", result)
end
