require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  def setup
    @hist = History.new(q: "1 2 +")
  end
  test "should be valid" do
    assert @hist.valid?
  end
  test "q should be non-empty" do
    @hist.q = " "
    assert_not @hist.valid?
  end
end