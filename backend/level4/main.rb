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
  attr_reader :insurrance, :assistance, :drivy, :total

  def initialize(price, days)
    @total = (price * 0.3).round
    @insurrance = total / 2
    @assistance = days * 100
    @drivy = total - insurrance - assistance
  end
end

def load_data(input_file)
  file = File.read(input_file)
  JSON.parse(file)
end

def write_data(output_file, result)
  File.write(output_file, JSON.pretty_generate(result) + "\n")
end

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

def compute_driver_debit(rental, cars)
  car = cars.find { |car| car.id == rental.car_id }
  price_for_days = compute_day_price(car.price_per_day, rental.days)
  price_for_kms = rental.distance * car.price_per_km
  price_for_days + price_for_kms
end

def format_actions(price, commission)
  [
    ["driver", "debit", price],
    ["owner", "credit", price - commission.total],
    ["insurance", "credit", commission.insurrance],
    ["assistance", "credit", commission.assistance],
    ["drivy", "credit", commission.drivy],
  ].map { |who, type, amount| {"who" => who, "type" => type, "amount" => amount}}
end

def format_rental_result(rental, cars)
  price = compute_driver_debit(rental, cars)
  com = Commission.new(price, rental.days)
  {
    :id => rental.id,
    :actions => format_actions(price, com),
  }
end

def solution
  json = load_data('data/input.json')
  cars = json["cars"].map { |car| Car.new(car) }
  rentals = json["rentals"].map { |rental| Rental.new(rental) }
  write_data('output.json',
             {:rentals => rentals.map { |rental| format_rental_result(rental, cars)}})
end
