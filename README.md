RangeSet
========

Do simple set operations on Ruby Ranges and RangeSets

RangeSet objects act like Ranges except that they may have any number of
gaps.

Limitations
-----------

This library is tested against integer ranges for my use case, but any
Comparable type should work, possible with a little bit of effort.

I have not implemented more of the Range interface in RangeSet than I
needed. If you need additional functionality, pull requests are welcome.
