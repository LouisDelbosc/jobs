require 'minitest/autorun'
require_relative 'main'
require "json"


class SolutionTest < Minitest::Test

  def test_car__nth_day_price
    car = Car.new({"id" => 1, "price_per_day" => 100, "price_per_km" => 0})
    assert_equal car.nth_day_price(1), 100
    assert_equal car.nth_day_price(2), 90
    assert_equal car.nth_day_price(5), 70
    assert_equal car.nth_day_price(11), 50
  end

  def test_car__compute_price
    car = Car.new({"id" => 1, "price_per_day" => 100, "price_per_km" => 0})
    assert_equal car.compute_price(1), 100
    assert_equal car.compute_price(2), 190
    assert_equal car.compute_price(5), 440
    assert_equal car.compute_price(11), 840
  end

  def test_rentals_options
    rental = { "id" => 1, "car_id" => 1, "start_date" => "2015-12-8",
               "end_date" => "2015-12-8", "distance" => 100 }
    options = [
      { "id" => 1, "rental_id" => 1, "type" => "gps" },
      { "id" => 2, "rental_id" => 1, "type" => "baby_seat" },
      { "id" => 3, "rental_id" => 2, "type" => "additional_insurance" }
    ]
    rental = Rental.new(rental, options)
    assert_equal rental.id, 1
    assert_equal rental.options, ['gps', 'baby_seat']
  end

  def test_rental__compute_price
    rental = { "id" => 1, "car_id" => 1, "start_date" => "2015-12-8",
               "end_date" => "2015-12-8", "distance" => 100 }
    rental = Rental.new(rental, [])
    cars = [Car.new({"id" => 1, "price_per_day" => 2000, "price_per_km" => 10})]
    assert_equal rental.compute_price(cars), 3000
  end

  def test_rental_actions__add_options
    actions = RentalActions.new(3000, 1)

    assert_equal actions.owner, 2100
    assert_equal actions.driver, -3000
    assert_equal actions.drivy, 350
    actions.add_options(1, ["gps", "additional_insurance", "additional_insurance"])

    assert_equal actions.owner, 2600
    assert_equal actions.driver, -4500
    assert_equal actions.drivy, 1350
  end

  def test_format_actions
    actions = RentalActions.new(3000, 1)
    assert_equal format_actions(actions), [
                   {"who" => "driver", "type" => "debit", "amount" => 3000},
                   {"who" => "owner", "type" => "credit", "amount" => 2100},
                   {"who" => "insurance", "type" => "credit", "amount" => 450},
                   {"who" => "assistance", "type" => "credit", "amount" => 100},
                   {"who" => "drivy", "type" => "credit", "amount" => 350}
                 ]
  end

  def test_solution
    solution()
    expected_output = File.read('./data/expected_output.json')
    output = File.read("./data/output.json")
    assert_equal JSON.parse(expected_output), JSON.parse(output)
  end
end
