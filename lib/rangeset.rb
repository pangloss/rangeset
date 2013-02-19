lib_path = File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
$:.unshift lib_path unless $:.any? { |path| path == lib_path }

require "rangeset/version"
require "rangeset/range"

class RangeSet
  class << self
    def [](*ranges)
      build ranges
    end

    def build(ranges)
      if ranges
        if ranges.is_a? Array
          ranges = ranges.compact
          if ranges.length == 1 and ranges.first.is_a? Range
            ranges.first
          elsif ranges.count == 0
            nil
          else
            RangeSet.new *ranges
          end
        elsif ranges.is_a? Range or ranges.is_a? RangeSet
          ranges
        elsif ranges.is_a? Fixnum
          ranges..ranges
        end
      end
    end

    def union(left, right)
      if not left
        right
      elsif not right
        left
      elsif left.is_a? Range and right.is_a? Range
        left.union right
      else
        RangeSet.new right, left
      end
    end

    def intersection(left, right)
      if not left or not right
        nil
      elsif left.is_a? Range and right.is_a? Range
        left.intersection right
      else
        left.ranges.reduce(nil) do |result, left|
          intersections = right.ranges.map do |right|
            left.intersection right
          end
          union(result, RangeSet.build(intersections))
        end
      end
    end

    def difference(left, right)
      if not right
        left
      elsif left
        left.ranges.reduce(nil) do |result, l|
          in_left = right.ranges.map do |r|
            l.difference(r)
          end
          in_left = in_left.reduce { |int, il|
            intersection int, il
          }
          union result, in_left
        end
      end
    end

    def diff(left, right, intersect_only = false)
      return [left, nil, nil] unless right
      return [nil, nil, right] unless left
      int = intersection(left, right)
      in_left = difference left, int
      in_right = difference right, int
      [in_left, int, in_right]
    end
  end

  include Enumerable

  attr_reader :ranges

  def initialize(*ranges)
    if ranges.length > 1
      @ranges = combine ranges
    else
      if ranges.first.is_a? RangeSet
        @ranges = ranges.first.ranges
      else
        @ranges = ranges
      end
    end
  end

  def combine(ranges)
    ranges = ranges.compact.flat_map do |r|
      if r.is_a? RangeSet
        r.ranges
      elsif r.is_a? Range
        [r]
      elsif r.is_a? Fixnum
        [r..r]
      else
        []
      end
    end
    ranges = ranges.compact.sort_by(&:first)
    result = [ranges.first]
    ranges[1..-1].each do |r|
      l = result.last
      if l.last >= r.first
        if l.last >= r.last
          next
        else
          result.pop
          r = l.first..r.last
        end
      elsif l.last + 1 == r.first
        result.pop
        r = l.first..r.last
      end
      result.push r
    end
    result
  end

  def gaps
    RangeSet.build ranges.each_cons(2).map { |a, b| (a.last + 1)..(b.first - 1) }
  end

  def each(&block)
    if block
      ranges.each do |range|
        range.each &block
      end
    else
      to_enum :each
    end
  end

  def first
    ranges.first.first
  end

  def last
    ranges.last.last
  end

  def include?(n)
    ranges.any? { |r| r.include? n }
  end

  def diff(other)
    RangeSet.diff self, other
  end

  def union(other)
    RangeSet.union self, other
  end

  def intersection(other)
    RangeSet.intersection self, other
  end

  def difference(other)
    RangeSet.difference self, other
  end

  def ==(other)
    !!(
      if other.is_a? RangeSet
        ranges == other.ranges
      elsif other.is_a? Range and ranges.count == 1
        ranges == [other]
      end)
  end

  def inspect
    "RangeSet#{ ranges.inspect }"
  end
end
