//
//  GuitarTuning.swift
//  NotGuitarSchool
//
//  Defines guitar tunings and helper accessors.
//

import Foundation

struct GuitarTuning {
    let name: String
    let strings: [(name: String, frequency: Float)]
}

enum GuitarTuningsCatalog {
    static let standardE: GuitarTuning = .init(
        name: "Стандарт (E A D G B E)",
        strings: [("E2", 82.41), ("A2", 110.00), ("D3", 146.83), ("G3", 196.00), ("B3", 246.94), ("E4", 329.63)]
    )

    static let dropD: GuitarTuning = .init(
        name: "Drop D",
        strings: [("D2", 73.42), ("A2", 110.00), ("D3", 146.83), ("G3", 196.00), ("B3", 246.94), ("E4", 329.63)]
    )

    static let openG: GuitarTuning = .init(
        name: "Open G",
        strings: [("D2", 73.42), ("G2", 98.00), ("D3", 146.83), ("G3", 196.00), ("B3", 246.94), ("D4", 293.66)]
    )

    static let halfStepDown: GuitarTuning = {
        let factor: Float = pow(2.0, -1.0/12.0)
        let base: [(String, Float)] = [("E2", 82.41), ("A2", 110.00), ("D3", 146.83), ("G3", 196.00), ("B3", 246.94), ("E4", 329.63)]
        let names = ["D#2", "G#2", "C#3", "F#3", "A#3", "D#4"]
        let shifted = base.enumerated().map { (idx, pair) in (names[idx], pair.1 * factor) }
        return GuitarTuning(name: "Полтона вниз (D# Standard)", strings: shifted)
    }()

    static let wholeStepDown: GuitarTuning = {
        let factor: Float = pow(2.0, -2.0/12.0)
        let base: [(String, Float)] = [("E2", 82.41), ("A2", 110.00), ("D3", 146.83), ("G3", 196.00), ("B3", 246.94), ("E4", 329.63)]
        let names = ["D2", "G2", "C3", "F3", "A3", "D4"]
        let shifted = base.enumerated().map { (idx, pair) in (names[idx], pair.1 * factor) }
        return GuitarTuning(name: "Тон вниз (D Standard)", strings: shifted)
    }()

    static let dropC: GuitarTuning = {
        let baseStd: [(String, Float)] = [("E2", 82.41), ("A2", 110.00), ("D3", 146.83), ("G3", 196.00), ("B3", 246.94), ("E4", 329.63)]
        let factorOthers: Float = pow(2.0, -2.0/12.0)
        let factorLow: Float = pow(2.0, -4.0/12.0)
        let shifted: [(String, Float)] = [
            ("C2", baseStd[0].1 * factorLow),
            ("G2", baseStd[1].1 * factorOthers),
            ("C3", baseStd[2].1 * factorOthers),
            ("F3", baseStd[3].1 * factorOthers),
            ("A3", baseStd[4].1 * factorOthers),
            ("D4", baseStd[5].1 * factorOthers)
        ]
        return GuitarTuning(name: "Drop C", strings: shifted)
    }()

    static let openD: GuitarTuning = .init(
        name: "Open D",
        strings: [("D2", 73.42), ("A2", 110.00), ("D3", 146.83), ("F#3", 185.00), ("A3", 220.00), ("D4", 293.66)]
    )

    static let openE: GuitarTuning = .init(
        name: "Open E",
        strings: [("E2", 82.41), ("B2", 123.47), ("E3", 164.81), ("G#3", 207.65), ("B3", 246.94), ("E4", 329.63)]
    )

    static let all: [GuitarTuning] = [
        standardE, dropD, openG, halfStepDown, wholeStepDown, dropC, openD, openE
    ]
}


