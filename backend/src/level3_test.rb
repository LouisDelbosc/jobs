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

  def test_commission
    com = Commission.new(3000, 1)
    assert_equal com.insurrance, 450
    assert_equal com.assistance, 100
    assert_equal com.drivy, 350
  end

  def test_solution_level3
    solution_level3()
    assert_equal File.read('../level3/data/expected_output.json'), File.read("output_level3.json")
  end
end
