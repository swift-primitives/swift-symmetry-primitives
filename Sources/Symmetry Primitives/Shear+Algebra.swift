// Shear+Algebra.swift
// Additive abelian group witness for 2D shear parameters.

public import Algebra_Group_Primitives

// MARK: - Abelian Group Witness

extension Shear where N == 2, Scalar: Sendable {
    /// Additive abelian group witness for 2D shear parameters.
    ///
    /// The group operation is component-wise addition of off-diagonal
    /// shear factors. This is NOT matrix multiplication (shear matrices
    /// are not closed under matrix multiplication). The structure is
    /// isomorphic to (R^2, +).
    @inlinable
    public static var group: Algebra.Group<Self>.Abelian {
        .init(group: .init(
            identity: .identity,
            combining: { lhs, rhs in
                Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
            },
            inverting: { shear in
                Self(x: -shear.x, y: -shear.y)
            }
        ))
    }

    /// Composes two shears by adding their off-diagonal parameters.
    @inlinable
    public func composed(with other: Self) -> Self {
        Self.group.combining(self, other)
    }

    /// Inverse shear (negation of off-diagonal parameters).
    @inlinable
    public var inverted: Self {
        Self.group.inverting(self)
    }
}
