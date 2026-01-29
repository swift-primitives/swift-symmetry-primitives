// Phase.swift

/// Discrete rotational phases: 0°, 90°, 180°, 270°.
///
/// Represents the cyclic group Z₄ of quarter-turn rotations. Forms a group under
/// composition with identity `zero`. Use when working with discrete rotations,
/// quadrant indexing, or cyclic patterns with period 4.
///
/// ## Example
///
/// ```swift
/// let phase: Phase = .quarter
/// print(phase.degrees)           // 90
/// print(phase.next)              // half
/// print(phase.opposite)          // threeQuarter
/// print(phase.composed(with: .half))  // threeQuarter
/// ```
public enum Phase: Ordinal, Sendable, Hashable, CaseIterable {
    /// 0° (identity, no rotation).
    case zero = 0

    /// 90° (quarter turn counterclockwise).
    case quarter = 1

    /// 180° (half turn).
    case half = 2

    /// 270° (three-quarter turn, or 90° clockwise).
    case threeQuarter = 3
}

// MARK: - Rotation

extension Phase {
    /// Next phase (90° counterclockwise rotation).
    @inlinable
    public static func next(of phase: Phase) -> Phase {
        Phase(rawValue: (phase.rawValue + Cardinal.one) % 4)!
    }

    /// Next phase (90° counterclockwise rotation).
    @inlinable
    public var next: Phase {
        Phase.next(of: self)
    }

    /// Previous phase (90° clockwise rotation).
    @inlinable
    public static func previous(of phase: Phase) -> Phase {
        Phase(rawValue: (phase.rawValue + Cardinal(3)) % 4)!
    }

    /// Previous phase (90° clockwise rotation).
    @inlinable
    public var previous: Phase {
        Phase.previous(of: self)
    }

    /// Opposite phase (180° rotation).
    @inlinable
    public static func opposite(of phase: Phase) -> Phase {
        Phase(rawValue: (phase.rawValue + Cardinal(2)) % 4)!
    }

    /// Opposite phase (180° rotation).
    @inlinable
    public var opposite: Phase {
        Phase.opposite(of: self)
    }

    /// Returns the opposite phase.
    @inlinable
    public static prefix func ! (value: Phase) -> Phase {
        value.opposite
    }
}

// MARK: - Composition

extension Phase {
    /// Composes two phases by adding rotations (modulo 4).
    @inlinable
    public static func composed(_ lhs: Phase, with rhs: Phase) -> Phase {
        Phase(rawValue: (lhs.rawValue + rhs.rawValue) % 4)!
    }

    /// Composes two phases by adding rotations (modulo 4).
    @inlinable
    public func composed(with other: Phase) -> Phase {
        Phase.composed(self, with: other)
    }

    /// Inverse phase (rotation that reverses this rotation).
    @inlinable
    public static func inverse(of phase: Phase) -> Phase {
        Phase(rawValue: (4 - phase.rawValue) % 4)!
    }

    /// Inverse phase (rotation that reverses this rotation).
    @inlinable
    public var inverse: Phase {
        Phase.inverse(of: self)
    }
}

// MARK: - Angle

extension Phase {
    /// Phase angle in degrees (0, 90, 180, or 270).
    @inlinable
    public var degrees: Int {
        rawValue * 90
    }

    /// Creates a phase from degrees (returns `nil` if not a multiple of 90).
    @inlinable
    public init?(degrees: Int) {
        let normalized = ((degrees % 360) + 360) % 360
        guard normalized % 90 == 0 else { return nil }
        self.init(rawValue: normalized / 90)
    }
}

// MARK: - Tagged Value

extension Phase {
    /// A value paired with a phase.
    public typealias Value<Payload> = Pair<Phase, Payload>
}

// MARK: - Finite.Enumerable

extension Phase: Finite.Enumerable {
    /// Number of phase values.
    @inlinable
    public static var count: Cardinal { 4 }

    /// Ordinal of this value (0: zero, 1: quarter, 2: half, 3: threeQuarter).
    @inlinable
    public var ordinal: Ordinal { rawValue }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = Phase(rawValue: ordinal)!
    }
}

// MARK: - Codable

#if !hasFeature(Embedded)
extension Phase: Codable {}
#endif
