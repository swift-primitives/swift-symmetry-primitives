// Phase.swift

public import Ordinal_Primitives
internal import Cardinal_Primitives
public import Finite_Primitives
public import Algebra_Primitives

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
public enum Phase: Int, Sendable, Hashable, CaseIterable {
    /// 0° (identity, no rotation).
    case zero = 0

    /// 90° (quarter turn counterclockwise).
    case quarter = 1

    /// 180° (half turn).
    case half = 2

    /// 270° (three-quarter turn, or 90° clockwise).
    case threeQuarter = 3
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
    public var ordinal: Ordinal { Ordinal(UInt(rawValue)) }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = Phase(rawValue: Int(ordinal.rawValue))!
    }
}

// MARK: - Codable

#if !hasFeature(Embedded)
extension Phase: Codable {}
#endif
