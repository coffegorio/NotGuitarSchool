//
//  TunaViewModel.swift
//  NotGuitarSchool
//

import AVFoundation
import Foundation

protocol TunaViewModelDelegate: AnyObject {
    func tunaViewModelDidUpdate(_ viewModel: TunaViewModel, frequency: Float?, noteName: String?, cents: Double?, deviationHz: Float?)
    func tunaViewModelDidChangeTuning(_ viewModel: TunaViewModel, tuningName: String)
    func tunaViewModelInTuneFeedback()
    func tunaViewModelMicPermissionDenied()
    func tunaViewModelAudioError(_ message: String)
}

final class TunaViewModel {
    weak var delegate: TunaViewModelDelegate?

    private let engine = AVAudioEngine()
    private var detector = PitchDetector(sampleRate: 44100)
    private var buffer: [Float] = []

    private(set) var tunings: [GuitarTuning] = GuitarTuningsCatalog.all
    private(set) var selectedIndex: Int = 0 {
        didSet { delegate?.tunaViewModelDidChangeTuning(self, tuningName: tunings[selectedIndex].name) }
    }

    private var lastInTune = false

    func requestPermissionAndStart() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            guard let self else { return }
            DispatchQueue.main.async {
                if granted { self.startAudio() } else { self.delegate?.tunaViewModelMicPermissionDenied() }
            }
        }
    }

    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
    }

    func selectTuning(index: Int) {
        guard index >= 0 && index < tunings.count else { return }
        selectedIndex = index
        buffer.removeAll()
    }

    private func startAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            delegate?.tunaViewModelAudioError("Ошибка аудио")
            return
        }

        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        detector.updateSampleRate(inputFormat.sampleRate)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { [weak self] buf, _ in
            guard let self else { return }
            if let pitch = self.detector.detectFrequency(buffer: buf) {
                self.addToBuffer(pitch)
                let smooth = self.smoothedFrequency()
                DispatchQueue.main.async { self.update(with: smooth) }
            } else {
                DispatchQueue.main.async { self.update(with: nil) }
            }
        }
        do { try engine.start() } catch { delegate?.tunaViewModelAudioError("Ошибка запуска Engine") }
    }

    private func addToBuffer(_ f: Float) {
        if let prev = buffer.last, abs(f - prev) > 30 {
            buffer.removeAll(); buffer.append(f); return
        }
        buffer.append(f)
        if buffer.count > 7 { buffer.removeFirst() }
    }

    private func smoothedFrequency() -> Float? {
        guard !buffer.isEmpty else { return nil }
        let sorted = buffer.sorted()
        return sorted[sorted.count/2]
    }

    private func update(with frequency: Float?) {
        guard let frequency else {
            lastInTune = false
            delegate?.tunaViewModelDidUpdate(self, frequency: nil, noteName: nil, cents: nil, deviationHz: nil)
            return
        }
        let tuning = tunings[selectedIndex]
        let closest = tuning.strings.min { abs($0.frequency - frequency) < abs($1.frequency - frequency) }!
        let deviation = frequency - closest.frequency
        let cents = 1200.0 * log2(Double(frequency) / Double(closest.frequency))

        delegate?.tunaViewModelDidUpdate(self, frequency: frequency, noteName: closest.name, cents: cents, deviationHz: deviation)

        if abs(deviation) < 1 {
            if !lastInTune { delegate?.tunaViewModelInTuneFeedback() }
            lastInTune = true
        } else {
            lastInTune = false
        }
    }
}


