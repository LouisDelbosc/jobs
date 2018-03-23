require "date"
require "json"


class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(json)
    @id = json["id"]
    @price_per_day = json["price_per_day"]
    @price_per_km = json["price_per_km"]
  end

  def nth_day_price(day)
    if day <= 1
      price_per_day
    elsif day <= 4
      price_per_day * 0.9
    elsif day <= 10
      price_per_day * 0.7
    else
      price_per_day * 0.5
    end
  end

  def compute_price(days)
    arr = Array.new(days, price_per_day)
    daily_price = arr.map.with_index { |price, index| nth_day_price(index + 1) }
    daily_price.reduce(0, :+).round
  end
end


class Rental
  attr_reader :id, :car_id, :days, :distance, :options

  def initialize(rental_json, option_json)
    @id = rental_json["id"]
    @car_id = rental_json["car_id"]
    @days = 1 + (Date.parse(rental_json["end_date"]) - Date.parse(rental_json["start_date"])).to_i
    @distance = rental_json["distance"]

    options = option_json.select { |option| option["rental_id"] == id }
    @options = options.map { |option| option["type"] }
  end

  def compute_price(cars)
    car = cars.find { |car| car.id == car_id }
    price_for_days = car.compute_price(days)
    price_for_kms = distance * car.price_per_km
    price_for_days + price_for_kms
  end
end


class RentalActions
  attr_reader :driver, :owner, :insurance, :assistance, :drivy

  def initialize(price_without_options, days)
    commission_amount = (price_without_options * 0.3).round

    @driver = -price_without_options
    @owner = price_without_options - commission_amount
    @insurance = commission_amount / 2
    @assistance = days * 100
    @drivy = commission_amount - insurance - assistance
  end

  def add_options(days, options)
    if options.include? "gps"
      @owner += 500 * days
      @driver -= 500 * days
    end

    if options.include? "baby_seat"
      @owner += 200 * days
      @driver -= 200 * days
    end

    if options.include? "additional_insurance"
      @drivy += 1000 * days
      @driver -= 1000 * days
    end
  end
end


def load_data(input_file)
  file = File.read(input_file)
  JSON.parse(file)
end

def write_data(output_file, result)
  File.write(output_file, JSON.pretty_generate(result) + "\n")
end

def format_actions(actions)
  {
    :driver => actions.driver,
    :owner => actions.owner,
    :insurance => actions.insurance,
    :assistance => actions.assistance,
    :drivy => actions.drivy
  } .map{ |who, amount| {
            "who" => who.to_s,
            "type" => amount > 0 ? "credit" : "debit",
            "amount" => amount.abs,
          }}
end

def format_result(rental, cars)
  price = rental.compute_price(cars)
  actions = RentalActions.new(price, rental.days)
  actions.add_options(rental.days, rental.options)
  {
    :id => rental.id,
    :options => rental.options,
    :actions => format_actions(actions),
  }
end

def solution
  json = load_data('data/input.json')
  cars = json["cars"].map { |car| Car.new(car) }
  rentals = json["rentals"].map { |rental| Rental.new(rental, json["options"]) }
  write_data('./data/output.json',
             {:rentals => rentals.map { |rental| format_result(rental, cars)}})
end
