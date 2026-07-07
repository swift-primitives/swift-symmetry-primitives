// Rotation.swift
// An N-dimensional rotation (element of SO(n), dimensionless).

public import Dimension_Primitives
public import Linear_Primitives
internal import Real_Primitives

/// An N-dimensional rotation in Euclidean space.
///
/// Represents an element of SO(n), the special orthogonal group. Rotations are dimensionless
/// angular displacements stored as orthogonal matrices with determinant +1, making them
/// independent of coordinate system units.
///
/// ## Example
///
/// ```swift
/// let rotation = Rotation<2, Double>(angle: .pi / 4)
/// let matrix = rotation.linear()
/// // [[cos(π/4), -sin(π/4)],
/// //  [sin(π/4),  cos(π/4)]]
/// ```
public struct Rotation<let N: Int, Scalar> {
    /// Orthogonal matrix representation with determinant +1.
    public var matrix: InlineArray<N, InlineArray<N, Scalar>>

    /// Creates a rotation from an orthogonal matrix.
    ///
    /// - Precondition: Matrix must be orthogonal with determinant +1 (not validated).
    @inlinable
    public init(matrix: consuming InlineArray<N, InlineArray<N, Scalar>>) {
        self.matrix = matrix
    }
}

extension Rotation: Sendable where Scalar: Sendable {}

// MARK: - Equatable (2D)

extension Rotation: Equatable where N == 2, Scalar: Equatable {
    /// Compares two rotations by their matrix entries.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.matrix[0][0] == rhs.matrix[0][0] && lhs.matrix[0][1] == rhs.matrix[0][1]
            && lhs.matrix[1][0] == rhs.matrix[1][0] && lhs.matrix[1][1] == rhs.matrix[1][1]
    }
}

// MARK: - Hashable (2D)

extension Rotation: Hashable where N == 2, Scalar: Hashable {
    /// Feeds this rotation's matrix entries into `hasher`.
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(matrix[0][0])
        hasher.combine(matrix[0][1])
        hasher.combine(matrix[1][0])
        hasher.combine(matrix[1][1])
    }
}

// MARK: - Codable (2D)

#if !hasFeature(Embedded)
    extension Rotation: Codable where N == 2, Scalar: Codable, Scalar: BinaryFloatingPoint {
        private enum CodingKeys: String, CodingKey {
            case a, b, c, d
        }

        // reason: signature forced by external protocol Swift.Decodable —
        // init(from:) requires untyped throws and an existential decoder.
        // swiftlint:disable no_any_protocol_existential typed_throws_required
        /// Decodes a rotation from its keyed matrix entries.
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let a = try container.decode(Scalar.self, forKey: .a)
            let b = try container.decode(Scalar.self, forKey: .b)
            let c = try container.decode(Scalar.self, forKey: .c)
            let d = try container.decode(Scalar.self, forKey: .d)
            var m = InlineArray<2, InlineArray<2, Scalar>>(
                repeating: InlineArray<2, Scalar>(repeating: .zero)
            )
            m[0][0] = a
            m[0][1] = b
            m[1][0] = c
            m[1][1] = d
            self.init(matrix: m)
        }
        // swiftlint:enable no_any_protocol_existential typed_throws_required

        // reason: signature forced by external protocol Swift.Encodable —
        // encode(to:) requires untyped throws and an existential encoder.
        // swiftlint:disable no_any_protocol_existential typed_throws_required
        /// Encodes this rotation as its keyed matrix entries.
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(matrix[0][0], forKey: .a)
            try container.encode(matrix[0][1], forKey: .b)
            try container.encode(matrix[1][0], forKey: .c)
            try container.encode(matrix[1][1], forKey: .d)
        }
        // swiftlint:enable no_any_protocol_existential typed_throws_required
    }
#endif

// MARK: - Identity

extension Rotation where Scalar: ExpressibleByIntegerLiteral {
    /// Identity rotation representing no angular displacement.
    @inlinable
    public static var identity: Self {
        var m = InlineArray<N, InlineArray<N, Scalar>>(
            repeating: InlineArray<N, Scalar>(repeating: 0)
        )
        for i in 0..<N {
            m[i][i] = 1
        }
        return Self(matrix: m)
    }
}

// MARK: - Conversion to Linear

extension Rotation where N == 2, Scalar: ExpressibleByIntegerLiteral {
    /// Converts to a 2D linear transformation matrix.
    @inlinable
    public func linear<Space>() -> Linear<Scalar, Space>.Matrix<2, 2> {
        .init(a: matrix[0][0], b: matrix[0][1], c: matrix[1][0], d: matrix[1][1])
    }
}

// MARK: - 2D Rotation - Numeric.Transcendental

extension Rotation where N == 2, Scalar: BinaryFloatingPoint & Numeric.Transcendental & Sendable {
    /// Rotation angle in radians.
    public var angle: Radian<Scalar> {
        get { Radian(_unchecked: Scalar._atan2(matrix[1][0], matrix[0][0])) }
        set { self = Self(angle: newValue) }
    }

    /// Creates a 2D rotation from an angle in radians.
    @inlinable
    public init(angle: Radian<Scalar>) {
        let c = angle.cos.value
        let s = angle.sin.value
        var m = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: .zero)
        )
        m[0][0] = c
        m[0][1] = -s
        m[1][0] = s
        m[1][1] = c
        self.init(matrix: m)
    }

    /// Creates a 2D rotation from an angle in degrees.
    @inlinable
    public init(degrees: Degree<Scalar>) {
        self.init(angle: degrees.radians)
    }

    /// Rotates by an additional angle in radians.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        concatenating(Self(angle: angle))
    }

    /// Rotates by an additional angle in degrees.
    @inlinable
    public func rotated(by degrees: Degree<Scalar>) -> Self {
        rotated(by: degrees.radians)
    }

    /// 90-degree counter-clockwise rotation.
    @inlinable
    public static var quarterTurn: Self {
        Self(angle: Radian<Scalar>(_unchecked: Scalar.pi / 2))
    }

    /// 180-degree rotation.
    @inlinable
    public static var halfTurn: Self {
        Self(angle: Radian<Scalar>(_unchecked: Scalar.pi))
    }

    /// 90-degree clockwise rotation.
    @inlinable
    public static var quarterTurnClockwise: Self {
        Self(angle: Radian<Scalar>(_unchecked: -Scalar.pi / 2))
    }
}

// MARK: - 2D Rotation - Generic (from precomputed sin/cos)

extension Rotation where N == 2, Scalar: AdditiveArithmetic & SignedNumeric {
    /// Creates a 2D rotation from precomputed cosine and sine values.
    @inlinable
    public init(cos: Scalar, sin: Scalar) {
        var m = InlineArray<2, InlineArray<2, Scalar>>(
            repeating: InlineArray<2, Scalar>(repeating: .zero)
        )
        m[0][0] = cos
        m[0][1] = -sin
        m[1][0] = sin
        m[1][1] = cos
        self.init(matrix: m)
    }
}
