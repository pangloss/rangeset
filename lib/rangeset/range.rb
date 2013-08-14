
# left         [1..10,            20..30,            40..50]
# right        [                       25..45,                49..55]
#
# left         ..........---------..........---------..........
# right        ------------------------....................---......
# in left only ..........         .....                    ...
# in both                              .....         ......
# in right only                             .........          .....
#              [[1..10, 20..24, 46..50],
#               [25..30, 40..45],
#               [31..39, 51..55]]

class Range
  class << self
    # [only in left, in both, only in right]
    def diff(left, right)
      return [left, nil, nil] unless right
      if left.is_a? RangeSet or right.is_a? RangeSet
        return RangeSet.diff left, right
      end
      a = left.first - right.first
      if left.first == right.first
        if left.last == right.last
          # 1..3, 1..3 -> [nil, 1..3, nil]
          [nil, left, nil]
        elsif left.last > right.last
          # 1..4, 1..2 -> [3..4, 1..2, nil]
          [right.last.next..left.last, right, nil]
        else
          # 1..2, 1..4 -> [nil, 1..2, 3..4]
          [nil, left, left.last.next..right.last]
        end
      elsif left.first < right.first
        if left.last == right.last
          # 1..4, 3..4 -> [1..2, 3..4, nil]
          [left.first..(right.first - 1), right.first..right.last, nil]
        elsif left.last > right.last
          # 1..6, 3..4 -> [[1..2, 5..6], 3..4, nil]
          [RangeSet.new(left.first..(right.first - 1), (right.last.next..left.last)), right, nil]
        elsif left.last < right.last
          if left.last < right.first
            # 1..3, 5..6 -> [1..3, nil, 5..6]
            [left, nil, right]
          elsif left.last >= right.first
            # 1..4, 3..6 -> [1..2, 3..4, 5..6]
            [left.first..(right.first - 1), right.first..left.last, left.last.next..right.last]
          end
        end
      else
        diff(right, left).reverse
      end
    end
  end

  def diff(other)
    Range.diff self, other
  end

  def difference(other)
    diff(other)[0]
  end

  def intersection(other)
    diff(other)[1]
  end

  def union(other)
    RangeSet.build [self, other]
  end

  def ranges
    [self]
  end

  unless instance_methods.include? :equal_without_rangeset
    alias :equal_without_rangeset :==
  end

  def ==(other)
    if other.is_a? RangeSet
      other == self
    else
      equal_without_rangeset other
    end
  end
end
