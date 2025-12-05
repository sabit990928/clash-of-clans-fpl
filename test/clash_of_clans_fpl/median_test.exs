defmodule MedianTest do
  use ExUnit.Case, async: true

  describe "calculate_median/1" do
    test "returns middle value for odd-length list" do
      assert Median.calculate_median([1, 2, 3]) == 2
      assert Median.calculate_median([1, 2, 3, 4, 5]) == 3
      assert Median.calculate_median([10, 20, 30, 40, 50, 60, 70]) == 40
    end

    test "returns rounded average of two middle values for even-length list" do
      assert Median.calculate_median([1, 2, 3, 4]) == 3
      assert Median.calculate_median([1, 2]) == 2
      assert Median.calculate_median([10, 20, 30, 40]) == 25
    end

    test "handles unsorted input by sorting first" do
      assert Median.calculate_median([5, 1, 3, 2, 4]) == 3
      assert Median.calculate_median([100, 1, 50, 25]) == 38
    end

    test "handles single element list" do
      assert Median.calculate_median([42]) == 42
      assert Median.calculate_median([0]) == 0
    end

    test "handles negative numbers" do
      assert Median.calculate_median([-5, -3, -1, 0, 2]) == -1
      assert Median.calculate_median([-10, -5]) == -8
    end

    test "handles duplicate values" do
      assert Median.calculate_median([5, 5, 5, 5, 5]) == 5
      assert Median.calculate_median([1, 1, 2, 2]) == 2
    end

    test "rounds down for fractional results" do
      # (3 + 4) / 2 = 3.5 -> rounds to 4
      assert Median.calculate_median([1, 3, 4, 6]) == 4
    end

    test "handles large numbers" do
      assert Median.calculate_median([1_000_000, 2_000_000, 3_000_000]) == 2_000_000
    end

    test "handles FPL-like point values" do
      # Typical FPL gameweek points
      points = [45, 52, 61, 38, 73, 55, 48, 67, 59, 42]
      # Sorted: [38, 42, 45, 48, 52, 55, 59, 61, 67, 73]
      # Middle values: 52, 55 -> (52 + 55) / 2 = 53.5 -> 54
      assert Median.calculate_median(points) == 54
    end
  end
end
