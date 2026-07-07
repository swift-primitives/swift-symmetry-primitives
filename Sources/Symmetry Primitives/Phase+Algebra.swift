// Phase+Algebra.swift
// Z4 cyclic abelian group witness for discrete rotational phases.

public import Algebra_Group_Primitives

// MARK: - Abelian Group Witness

extension Phase {
    /// Z4 cyclic abelian group witness.
    ///
    /// The group operation is addition modulo 4 on rawValues.
    /// Commutativity holds because integer addition is commutative.
    @inlinable
    public static var group: Algebra.Group<Phase>.Abelian {
        .init(
            group: .init(
                identity: .zero,
                combining: { lhs, rhs in
                    guard let result = Phase(rawValue: (lhs.rawValue + rhs.rawValue) % 4) else {
                        preconditionFailure("Phase rawValue mod 4 is always in 0...3")
                    }
                    return result
                },
                inverting: { phase in
                    guard let result = Phase(rawValue: (4 - phase.rawValue) % 4) else {
                        preconditionFailure("Phase rawValue mod 4 is always in 0...3")
                    }
                    return result
                }
            )
        )
    }

    /// Composes two phases by adding rotations (modulo 4).
    @inlinable
    public func composed(with other: Phase) -> Phase {
        Self.group.combining(self, other)
    }

    /// Inverse phase (rotation that reverses this rotation).
    @inlinable
    public var inverse: Phase {
        Self.group.inverting(self)
    }
}

// MARK: - Geometric Convenience

extension Phase {
    /// Next phase (90° counterclockwise rotation).
    @inlinable
    public var next: Phase {
        Self.group.combining(self, .quarter)
    }

    /// Previous phase (90° clockwise rotation).
    @inlinable
    public var previous: Phase {
        Self.group.combining(self, .threeQuarter)
    }

    /// Opposite phase (180° rotation).
    @inlinable
    public var opposite: Phase {
        Self.group.combining(self, .half)
    }

    /// Returns the opposite phase.
    @inlinable
    public static prefix func ! (value: Phase) -> Phase {
        value.opposite
    }
}
