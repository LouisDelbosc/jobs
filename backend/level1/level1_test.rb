require 'minitest/autorun'
require_relative 'main'

def create_cars
  cars = [
    { "id" => 1, "price_per_day" => 2000, "price_per_km" => 10 },
    { "id" => 2, "price_per_day" => 3000, "price_per_km" => 15 },
    { "id" => 3, "price_per_day" => 1700, "price_per_km" => 8 }
  ]
  cars.map { |car| Car.new(car) }
end

def create_rentals
  rentals = [
    { "id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 100 },
    { "id" => 2, "car_id" => 1, "start_date" => "2017-12-14", "end_date" => "2017-12-18", "distance" => 550 },
    { "id" => 3, "car_id" => 2, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 150 }
  ]
  rentals.map { |rental| Rental.new(rental) }
end

class SolutionTest < Minitest::Test

  def test_car_class
    car = create_cars()[0]
    assert_equal car.id, 1
    assert_equal car.price_per_day, 2000
    assert_equal car.price_per_km, 10
  end

  def test_rental_class
    rental = create_rentals()[0]
    assert_equal rental.id, 1
    assert_equal rental.car_id, 1
    assert_equal rental.days, 3
    assert_equal rental.distance, 100
  end

  def test_compute_rental_price
    rental = Rental.new({
      "id" => 1,
      "car_id" => 1,
      "start_date" => "2017-12-8",
      "end_date" => "2017-12-10",
      "distance" => 100
    })
    assert_equal compute_rental_price(rental, create_cars()), 7000
  end

  def test_format_result
    result = {
      :rentals => [
        {:id => 1, :price => 7000},
        {:id => 2, :price => 15500},
        {:id => 3, :price => 11250}
      ]
    }
    rentals = create_rentals()
    cars = create_cars()
    assert_equal format_result(rentals, cars), result
  end

  def test_solution
    input = {
      "cars" => [
        { "id" => 1, "price_per_day" => 2000, "price_per_km" => 10 },
        { "id" => 2, "price_per_day" => 3000, "price_per_km" => 15 },
        { "id" => 3, "price_per_day" => 1700, "price_per_km" => 8 }
      ],
      "rentals" => [
        { "id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 100 },
        { "id" => 2, "car_id" => 1, "start_date" => "2017-12-14", "end_date" => "2017-12-18", "distance" => 550 },
        { "id" => 3, "car_id" => 2, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 150 }
      ]
    }
    assert_equal solution(input), {
                   :rentals => [
                     {:id => 1, :price => 7000},
                     {:id => 2, :price => 15500},
                     {:id => 3, :price => 11250}
                   ]
                 }
  end
end
