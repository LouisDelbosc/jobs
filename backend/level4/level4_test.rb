require 'minitest/autorun'
require_relative 'main'
require "json"

class SolutionTest < Minitest::Test

  def test_commission
    com = Commission.new(3000, 1)
    assert_equal com.insurrance, 450
    assert_equal com.assistance, 100
    assert_equal com.drivy, 350
    assert_equal com.total, 900
  end

  def test_format_actions
    com = Commission.new(3000, 1)
    assert_equal format_actions(3000, com), [
                   {
                     "who" => "driver",
                     "type" => "debit",
                     "amount" => 3000
                   },
                   {
                     "who" => "owner",
                     "type" => "credit",
                     "amount" => 2100
                   },
                   {
                     "who" => "insurance",
                     "type" => "credit",
                     "amount" => 450
                   },
                   {
                     "who" => "assistance",
                     "type" => "credit",
                     "amount" => 100
                   },
                   {
                     "who" => "drivy",
                     "type" => "credit",
                     "amount" => 350
                   }
                 ]
  end

  def test_solution
    solution()
    assert_equal File.read('./data/expected_output.json'), File.read("output.json")
  end
end
