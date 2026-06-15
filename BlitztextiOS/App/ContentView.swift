import SwiftUI

struct ContentView: View {
    @ObservedObject var model: BlitztextDictationModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    dictationCard
                    transcriptCard
                    settingsCard
                    keyboardCard
                }
                .padding()
            }
            .navigationTitle("Blitztext")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Blitztext für iPhone")
                .font(.title2.weight(.semibold))
            Text("Diktiere in der App, kopiere automatisch und füge über die Blitztext-Tastatur direkt ins aktive Textfeld ein.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var dictationCard: some View {
        VStack(spacing: 16) {
            Button {
                switch model.phase {
                case .recording:
                    model.stopAndTranscribe()
                default:
                    model.startRecording()
                }
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: model.phase == .recording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 34, weight: .semibold))
                    Text(model.phase == .recording ? "Stoppen" : "Diktat starten")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 26)
                .foregroundStyle(.white)
                .background(model.phase == .recording ? Color.red : Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            phaseView
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var phaseView: some View {
        switch model.phase {
        case .idle:
            Text(model.hasAPIKey ? "Bereit." : "Bitte API Key speichern.")
                .foregroundStyle(.secondary)
        case .recording:
            ProgressView(value: Double(model.recorder.audioLevel))
            Text("Ich höre zu.")
                .foregroundStyle(.secondary)
        case .transcribing:
            HStack {
                ProgressView()
                Text("Wird transkribiert ...")
                    .foregroundStyle(.secondary)
            }
        case .done:
            Label("Text ist bereit und in der Zwischenablage.", systemImage: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .error(let message):
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
        }
    }

    private var transcriptCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Letzte Ausgabe")
                    .font(.headline)
                Spacer()
                Button("Kopieren") {
                    model.copyLastTranscript()
                }
                .disabled(model.lastTranscript.isEmpty)
            }

            Text(model.lastTranscript.isEmpty ? "Noch kein Transkript." : model.lastTranscript)
                .font(.body)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if !model.statusText.isEmpty {
                Text(model.statusText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Einstellungen")
                .font(.headline)

            SecureField(model.hasAPIKey ? "API Key gespeichert" : "OpenAI API Key", text: $model.apiKeyDraft)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            TextField("Sprache, z.B. de", text: $model.language)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            TextField("Fachbegriffe, durch Kommas getrennt", text: $model.customTermsText, axis: .vertical)
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)

            Button("Speichern") {
                model.saveSettings()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var keyboardCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tastatur aktivieren")
                .font(.headline)
            Text("Aktiviere Blitztext unter Einstellungen > Allgemein > Tastatur > Tastaturen. Die Tastatur kann die letzte Ausgabe direkt ins aktive Textfeld einfügen.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
