import AVFoundation
import Foundation
import Combine

final class BlitztextAudioRecorder: NSObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    @Published var audioLevel: Float = 0
    @Published var recordingURL: URL?
    @Published var errorMessage: String?
    @Published var lastRecordingDuration: TimeInterval = 0

    private var recorder: AVAudioRecorder?
    private var levelTimer: Timer?
    private var currentURL: URL?

    func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    func startRecording() {
        errorMessage = nil
        recordingURL = nil
        lastRecordingDuration = 0

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)

            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("blitztext-ios-\(UUID().uuidString).m4a")
            currentURL = url

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.record()
            isRecording = true
            startMetering()
        } catch {
            errorMessage = "Aufnahme konnte nicht gestartet werden: \(error.localizedDescription)"
            currentURL = nil
            recorder = nil
            isRecording = false
        }
    }

    func stopRecording() -> URL? {
        stopMetering()
        lastRecordingDuration = recorder?.currentTime ?? 0
        recorder?.stop()
        recorder = nil
        isRecording = false
        audioLevel = 0
        recordingURL = currentURL
        currentURL = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        return recordingURL
    }

    func discardRecording() {
        if let recordingURL {
            try? FileManager.default.removeItem(at: recordingURL)
        }
        if let currentURL {
            try? FileManager.default.removeItem(at: currentURL)
        }
        recordingURL = nil
        currentURL = nil
    }

    private func startMetering() {
        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.recorder?.updateMeters()
            let power = self.recorder?.averagePower(forChannel: 0) ?? -160
            self.audioLevel = max(0, min(1, (power + 50) / 50))
        }
    }

    private func stopMetering() {
        levelTimer?.invalidate()
        levelTimer = nil
    }
}

extension BlitztextAudioRecorder: ObservableObject {}
