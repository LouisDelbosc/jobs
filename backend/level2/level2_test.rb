require 'minitest/autorun'
require_relative 'main'
require "json"

def create_cars
  cars = [
    { "id" => 1, "price_per_day" => 2000, "price_per_km" => 10 }
  ]
  cars.map { |car| Car.new(car) }
end

def create_rentals
  rentals = [
    { "id" => 1, "car_id" => 1, "start_date" => "2015-12-8", "end_date" => "2015-12-8", "distance" => 100 },
    { "id" => 2, "car_id" => 1, "start_date" => "2015-03-31", "end_date" => "2015-04-01", "distance" => 300 },
    { "id" => 3, "car_id" => 1, "start_date" => "2015-07-3", "end_date" => "2015-07-14", "distance" => 1000 }
  ]
  rentals.map { |rental| Rental.new(rental) }
end

class SolutionTest < Minitest::Test

  def test_car_price_per_rental_day
    assert_equal car_price_for_rental_day(100, 1), 100
    assert_equal car_price_for_rental_day(100, 2), 90
    assert_equal car_price_for_rental_day(100, 5), 70
    assert_equal car_price_for_rental_day(100, 11), 50
  end

  def test_car_price_days
    assert_equal compute_day_price(100, 1), 100
    assert_equal compute_day_price(100, 2), 190
    assert_equal compute_day_price(100, 5), 440
    assert_equal compute_day_price(100, 11), 840
  end

  def test_compute_rental_price_level2
    rentals = create_rentals()
    cars = create_cars()
    assert_equal compute_rental_price(rentals[0], cars), 3000
    assert_equal compute_rental_price(rentals[1], cars), 6800
    assert_equal compute_rental_price(rentals[2], cars), 27800
  end

  def test_solution
    solution()
    assert_equal File.read('./data/expected_output.json'), File.read("./data/output.json")
  end
end
