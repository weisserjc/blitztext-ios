import Combine
import Foundation
import UIKit

@MainActor
final class BlitztextDictationModel: ObservableObject {
    enum Phase: Equatable {
        case idle
        case recording
        case transcribing
        case done
        case error(String)
    }

    @Published var phase: Phase = .idle
    @Published var apiKeyDraft = ""
    @Published var customTermsText = ""
    @Published var language = BlitztextSharedStore.language
    @Published var lastTranscript = BlitztextSharedStore.lastTranscript
    @Published var statusText = ""

    let recorder = BlitztextAudioRecorder()

    var hasAPIKey: Bool {
        BlitztextKeychain.load(.openAIAPIKey) != nil
    }

    init() {
        customTermsText = BlitztextSharedStore.customTerms.joined(separator: ", ")
    }

    func saveSettings() {
        let trimmedKey = apiKeyDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedKey.isEmpty {
            do {
                try BlitztextKeychain.save(trimmedKey, for: .openAIAPIKey)
                apiKeyDraft = ""
                statusText = "API Key gespeichert."
            } catch {
                phase = .error(error.localizedDescription)
            }
        }

        let terms = customTermsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        BlitztextSharedStore.customTerms = terms
        BlitztextSharedStore.language = language
    }

    func startRecording() {
        Task {
            guard await recorder.requestPermission() else {
                phase = .error("Mikrofonzugriff fehlt.")
                return
            }
            saveSettings()
            recorder.startRecording()
            if let error = recorder.errorMessage {
                phase = .error(error)
            } else {
                phase = .recording
            }
        }
    }

    func stopAndTranscribe() {
        guard let url = recorder.stopRecording() else {
            phase = .error("Keine Aufnahme vorhanden.")
            return
        }

        guard recorder.lastRecordingDuration >= 0.3 else {
            recorder.discardRecording()
            phase = .error("Aufnahme war zu kurz.")
            return
        }

        guard let apiKey = BlitztextKeychain.load(.openAIAPIKey) else {
            phase = .error("Bitte zuerst OpenAI API Key speichern.")
            return
        }

        phase = .transcribing
        Task {
            do {
                let text = try await OpenAITranscriptionClient.transcribe(
                    audioURL: url,
                    apiKey: apiKey,
                    customTerms: BlitztextSharedStore.customTerms,
                    language: language
                )
                try? FileManager.default.removeItem(at: url)
                BlitztextSharedStore.lastTranscript = text
                BlitztextSharedStore.markLastTranscriptForAutoInsert()
                UIPasteboard.general.string = text
                lastTranscript = text
                statusText = "Transkribiert, kopiert und für die Tastatur bereit."
                phase = .done
            } catch {
                try? FileManager.default.removeItem(at: url)
                phase = .error(error.localizedDescription)
            }
        }
    }

    func copyLastTranscript() {
        UIPasteboard.general.string = lastTranscript
        statusText = "Kopiert."
    }
}
