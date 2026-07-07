// Rotation Tests.swift

import Affine_Primitives
import Dimension_Primitives
import Linear_Primitives
import Real_Primitives
import Testing

@testable import Symmetry_Primitives

@Suite
struct `Rotation Tests` {

    // MARK: - Identity

    @Test
    func `Identity is correctly initialized`() {
        let identity = Rotation<2, Double>.identity
        #expect(identity.matrix[0][0] == 1)
        #expect(identity.matrix[1][1] == 1)
        #expect(identity.matrix[0][1] == 0)
        #expect(identity.matrix[1][0] == 0)
    }

    // MARK: - Initialization

    @Test
    func `Initialize from angle`() {
        let rotation = Rotation<2, Double>(angle: .pi / 4)
        let angle = .pi / 4.0

        // Check that matrix represents rotation by π/4
        #expect(abs(rotation.matrix[0][0] - Double.math.cos(angle)) < 1e-10)
        #expect(abs(rotation.matrix[1][1] - Double.math.cos(angle)) < 1e-10)
        #expect(abs(rotation.matrix[1][0] - Double.math.sin(angle)) < 1e-10)
        #expect(abs(rotation.matrix[0][1] + Double.math.sin(angle)) < 1e-10)
    }

    @Test
    func `Initialize from degrees`() {
        let rotation = Rotation<2, Double>(degrees: Degree(90))

        // 90 degrees is π/2 radians
        #expect(abs(rotation.matrix[0][0]) < 1e-10)  // Double.math.cos(π/2) ≈ 0
        #expect(abs(rotation.matrix[1][1]) < 1e-10)  // Double.math.cos(π/2) ≈ 0
        #expect(abs(rotation.matrix[1][0] - 1) < 1e-10)  // Double.math.sin(π/2) ≈ 1
        #expect(abs(rotation.matrix[0][1] + 1) < 1e-10)  // -Double.math.sin(π/2) ≈ -1
    }

    @Test
    func `Initialize from cos and sin`() {
        let rotation = Rotation<2, Double>(cos: 0.6, sin: 0.8)
        #expect(rotation.matrix[0][0] == 0.6)
        #expect(rotation.matrix[1][1] == 0.6)
        #expect(rotation.matrix[1][0] == 0.8)
        #expect(rotation.matrix[0][1] == -0.8)
    }

    // MARK: - Angle property

    @Test
    func `Angle property returns correct value`() {
        let rotation = Rotation<2, Double>(angle: .pi / 3)
        let bool = abs(rotation.angle - .pi / 3) < 1e-10
        #expect(bool == true)
    }

    @Test
    func `Angle property can be set`() {
        var rotation = Rotation<2, Double>(angle: .pi / 4)
        rotation.angle = .pi / 2
        let bool = abs(rotation.angle - .pi / 2) < 1e-10
        #expect(bool == true)
    }

    // MARK: - Static concatenate function

    @Test
    func `Static concatenate composes rotations`() {
        let rotation1 = Rotation<2, Double>(angle: .pi / 4)  // 45°
        let rotation2 = Rotation<2, Double>(angle: .pi / 4)  // 45°
        let result = rotation1.concatenating(rotation2)

        // Should equal 90° rotation
        let bool = abs(result.angle - .pi / 2) < 1e-10
        #expect(bool == true)
    }

    @Test
    func `Static concatenate with identity returns original`() {
        let rotation = Rotation<2, Double>(angle: .pi / 3)
        let identity = Rotation<2, Double>.identity
        let result = rotation.concatenating(identity)

        #expect(abs(result.angle - rotation.angle) < 1e-10)
    }

    @Test
    func `Concatenating instance method works`() {
        let rotation1 = Rotation<2, Double>(angle: .pi / 6)  // 30°
        let rotation2 = Rotation<2, Double>(angle: .pi / 3)  // 60°
        let result = rotation1.concatenating(rotation2)

        // Should equal 90° rotation (30° + 60°)
        let bool = abs(result.angle - .pi / 2) < 1e-10
        #expect(bool == true)
    }

    // MARK: - Static inverted function

    @Test
    func `Static inverted returns inverse rotation`() {
        let rotation = Rotation<2, Double>(angle: .pi / 4)
        let inverted = rotation.inverted

        #expect(abs(inverted.angle + rotation.angle) < 1e-10)
    }

    @Test
    func `Static inverted of identity is identity`() {
        let identity = Rotation<2, Double>.identity
        let inverted = identity.inverted

        #expect(inverted.matrix[0][0] == 1)
        #expect(inverted.matrix[1][1] == 1)
        #expect(inverted.matrix[0][1] == 0)
        #expect(inverted.matrix[1][0] == 0)
    }

    @Test
    func `Inverted instance property works`() {
        let rotation = Rotation<2, Double>(angle: .pi / 3)
        let inverted = rotation.inverted

        #expect(abs(inverted.angle + rotation.angle) < 1e-10)
    }

    @Test
    func `Composition with inverse yields identity`() {
        let rotation = Rotation<2, Double>(angle: .pi / 5)
        let inverted = rotation.inverted
        let result = rotation.concatenating(inverted)

        // Result should be identity
        #expect(abs(result.matrix[0][0] - 1) < 1e-10)
        #expect(abs(result.matrix[1][1] - 1) < 1e-10)
        #expect(abs(result.matrix[0][1]) < 1e-10)
        #expect(abs(result.matrix[1][0]) < 1e-10)
    }

    // MARK: - Common rotations

    @Test
    func `Quarter turn is 90 degrees`() {
        let quarterTurn = Rotation<2, Double>.quarterTurn
        let bool = abs(quarterTurn.angle - .pi / 2) < 1e-10
        #expect(bool == true)
    }

    @Test
    func `Half turn is 180 degrees`() {
        let halfTurn = Rotation<2, Double>.halfTurn
        #expect(abs(abs(halfTurn.angle) - .pi) < 1e-10)
    }

    @Test
    func `Quarter turn clockwise is -90 degrees`() {
        let quarterTurnCW = Rotation<2, Double>.quarterTurnClockwise
        let bool = abs(quarterTurnCW.angle + .pi / 2) < 1e-10
        #expect(bool == true)
    }

    // MARK: - Rotated by convenience methods

    @Test
    func `Rotated by angle works`() {
        let rotation = Rotation<2, Double>(angle: Radian<Double>.pi / 6)
        let rotated = rotation.rotated(by: Radian<Double>.pi / 3)

        let bool = abs(rotated.angle - .pi / 2) < 1e-10
        #expect(bool == true)
    }

    @Test
    func `Rotated by degrees works`() {
        let rotation = Rotation<2, Double>(angle: .pi / 4)
        let rotated = rotation.rotated(by: Degree(45))

        let bool = abs(rotated.angle - .pi / 2) < 1e-10
        #expect(bool == true)
    }

    // MARK: - Equatable

    @Test
    func `Equal rotations are equal`() {
        let rotation1 = Rotation<2, Double>(angle: .pi / 4)
        let rotation2 = Rotation<2, Double>(angle: .pi / 4)

        #expect(rotation1 == rotation2)
    }

    @Test
    func `Different rotations are not equal`() {
        let rotation1 = Rotation<2, Double>(angle: .pi / 4)
        let rotation2 = Rotation<2, Double>(angle: .pi / 3)

        #expect(rotation1 != rotation2)
    }

    // MARK: - Linear conversion

    @Test
    func `Linear conversion produces correct matrix`() {
        let rotation = Rotation<2, Double>(angle: .pi / 4)
        let linear: Linear<Double, Void>.Matrix<2, 2> = rotation.linear()

        #expect(abs(linear.a - Double.math.cos(.pi / 4)) < 1e-10)
        #expect(abs(linear.b + Double.math.sin(.pi / 4)) < 1e-10)
        #expect(abs(linear.c - Double.math.sin(.pi / 4)) < 1e-10)
        #expect(abs(linear.d - Double.math.cos(.pi / 4)) < 1e-10)
    }
}
