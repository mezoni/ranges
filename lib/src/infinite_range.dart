part of ranges;

class InfiniteRange {
  final double from;

  final double to;

  InfiniteRange(this.from, this.to) {
    if (from == null) {
      throw new ArgumentError("from: $from");
    }

    if (to == null) {
      throw new ArgumentError("to: $to");
    }

    if (from.isNaN) {
      throw new StateError("'from' is NAN");
    }

    if (to.isNaN) {
      throw new StateError("'to' is NAN");
    }

    if (from == double.INFINITY) {
      throw new StateError("'from' is POSITIVE_INFINITY");
    }

    if (to == double.NEGATIVE_INFINITY) {
      throw new StateError("'to' is NEGATIVE_INFINITY");
    }

    if (from > to) {
      throw new StateError("From '$from' greater then to '$to'");
    }
  }

  double get length => to - from;

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is InfiniteRange) {
      return from == other.from && to == other.to;
    }

    return false;
  }

  InfiniteRange operator +(InfiniteRange other) {
    if (other == null) {
      throw new ArgumentError("other: $other");
    }

    double from;
    double to;
    if (this.from < other.from) {
      from = this.from;
    } else {
      from = other.from;
    }

    if (this.to > other.to) {
      to = this.to;
    } else {
      to = other.to;
    }

    return new InfiniteRange(from, to);
  }

  /**
   * Returns true if range contains the [value]; otherwise false.
   */
  bool contains(double value) {
    if (value == null || value > to || value < to) {
      return false;
    }

    return true;
  }

  /**
   * Returns true if this range includes [other]; otherwise false.
   */
  bool includes(InfiniteRange other) {
    if (other == null) {
      throw new ArgumentError("other: $other");
    }

    return (other.from >= from && other.from <= to) && (other.to >= from && other.to <= to);
  }

  /**
   * Returns true if this range intersect [other]; otherwise false.
   */
  bool intersect(InfiniteRange other) {
    if (other == null) {
      throw new ArgumentError("other: $other");
    }

    return (from <= other.from && to >= other.from) || (other.from <= from && other.to >= from);
  }

  /**
   * Returns the intersection of this range and the [other] range; otherwise
   * null.
   */
  InfiniteRange intersection(InfiniteRange other) {
    if (other == null) {
      throw new ArgumentError("other: $other");
    }

    if (!intersect(other)) {
      return null;
    }

    if (this == other) {
      return new InfiniteRange(this.from, this.to);
    }

    var from = this.from;
    if (other.from > from) {
      from = other.from;
    }

    var to = this.to;
    if (other.to < to) {
      to = other.to;
    }

    return new InfiniteRange(from, to);
  }

  /**
   * Subtracts from this range the [other] range and returns the the resulting
   * ranges.
   */
  List<InfiniteRange> subtract(InfiniteRange other) {
    if (other == null) {
      throw new ArgumentError("other: $other");
    }

    var result = <InfiniteRange>[];
    if (!intersect(other)) {
      return result;
    }

    if (from < other.from) {
      result.add(new InfiniteRange(from, other.from - 1));
    }

    if (other.to < to) {
      result.add(new InfiniteRange(other.to + 1, to));
    }

    return result;
  }
}
