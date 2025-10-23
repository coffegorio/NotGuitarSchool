//
//  PitchDetector.swift
//  NotGuitarSchool
//

import AVFoundation

final class PitchDetector {
    private var sampleRate: Double

    init(sampleRate: Double) {
        self.sampleRate = sampleRate
    }

    func updateSampleRate(_ rate: Double) {
        self.sampleRate = rate
    }

    // Simple autocorrelation-based pitch detection
    func detectFrequency(buffer: AVAudioPCMBuffer) -> Float? {
        guard let channelData = buffer.floatChannelData?[0] else { return nil }
        let frameLength = Int(buffer.frameLength)
        if frameLength < 1024 { return nil }

        var maxAutocorr: Float = 0
        var bestLag = 0

        let minFreq: Double = 60
        let maxFreq: Double = 1000
        let minLag = max(1, Int(self.sampleRate / maxFreq))
        let maxLag = min(Int(self.sampleRate / minFreq), frameLength - 1)
        if minLag >= maxLag { return nil }

        for lag in minLag...maxLag {
            var sum: Float = 0
            for i in 0..<(frameLength - lag) { sum += channelData[i] * channelData[i + lag] }
            if sum > maxAutocorr {
                maxAutocorr = sum
                bestLag = lag
            }
        }
        guard maxAutocorr > 1e-2 else { return nil }
        let frequency = Float(sampleRate) / Float(bestLag)
        if frequency < 60 || frequency > 1300 { return nil }
        return frequency
    }
}


