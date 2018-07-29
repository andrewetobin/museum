require 'minitest/autorun'
require 'minitest/emoji'
require './lib/patron'
require './lib/museum'

class MuseumTest < Minitest::Test

  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @bob = Patron.new("Bob")
    @sally = Patron.new("Sally")
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_starts_with_no_exhibits
    assert_equal ({}), @dmns.exhibits
  end

  def test_it_can_add_exhibits
    @dmns.add_exhibit("Dead Sea Scrolls", 10)
    @dmns.add_exhibit("Gems and Minerals", 0)

    assert_equal ({"Dead Sea Scrolls"=>10, "Gems and Minerals"=>0}), @dmns.exhibits
  end

  def test_it_can_calculate_revenue
    @dmns.add_exhibit("Dead Sea Scrolls", 10)
    @dmns.add_exhibit("Gems and Minerals", 0)
    @bob.add_interest("Gems and Minerals")
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Imax")
    @sally.add_interest("Dead Sea Scrolls")
    assert_equal 0, @dmns.revenue

    @dmns.admit(@bob)
    @dmns.admit(@sally)
    assert_equal [@bob, @sally], @dmns.patrons
    assert_equal 40, @dmns.revenue
  end

  def test_patrons_of
    @dmns.add_exhibit("Dead Sea Scrolls", 10)
    @dmns.add_exhibit("Gems and Minerals", 0)
    @bob.add_interest("Gems and Minerals")
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Imax")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    assert_equal ['Bob', 'Sally'], @dmns.patrons_of("Dead Sea Scrolls")
  end

  def test_exhibits_by_attendees
    @dmns.add_exhibit("Dead Sea Scrolls", 10)
    @dmns.add_exhibit("Gems and Minerals", 0)
    @bob.add_interest("Gems and Minerals")
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Imax")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    assert_equal ["Dead Sea Scrolls", "Gems and Minerals"], @dmns.exhibits_by_attendees
  end

  def test_remove_unpopular_exhibits
    @dmns.add_exhibit("Dead Sea Scrolls", 10)
    @dmns.add_exhibit("Gems and Minerals", 0)
    @bob.add_interest("Gems and Minerals")
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Imax")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    assert_equal ["Dead Sea Scrolls"], @dmns.remove_unpopular_exhibits(2)
  end
end
