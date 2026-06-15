import Foundation

enum BlitztextSharedStore {
    static let appGroupIdentifier = "group.app.blitztext.shared"

    private enum Key {
        static let lastTranscript = "lastTranscript"
        static let lastTranscriptID = "lastTranscriptID"
        static let lastTranscriptDate = "lastTranscriptDate"
        static let pendingAutoInsertID = "pendingAutoInsertID"
        static let customTerms = "customTerms"
        static let language = "language"
    }

    static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    static var lastTranscript: String {
        get { defaults.string(forKey: Key.lastTranscript) ?? "" }
        set {
            defaults.set(newValue, forKey: Key.lastTranscript)
            defaults.set(UUID().uuidString, forKey: Key.lastTranscriptID)
            defaults.set(Date(), forKey: Key.lastTranscriptDate)
        }
    }

    static var lastTranscriptID: String {
        defaults.string(forKey: Key.lastTranscriptID) ?? ""
    }

    static var lastTranscriptDate: Date? {
        defaults.object(forKey: Key.lastTranscriptDate) as? Date
    }

    static var customTerms: [String] {
        get { defaults.stringArray(forKey: Key.customTerms) ?? [] }
        set { defaults.set(newValue, forKey: Key.customTerms) }
    }

    static var language: String {
        get { defaults.string(forKey: Key.language) ?? "de" }
        set { defaults.set(newValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: Key.language) }
    }

    static func markLastTranscriptForAutoInsert() {
        let id = lastTranscriptID
        guard !id.isEmpty else { return }
        defaults.set(id, forKey: Key.pendingAutoInsertID)
    }

    static func consumePendingAutoInsert() -> String? {
        let pendingID = defaults.string(forKey: Key.pendingAutoInsertID) ?? ""
        guard !pendingID.isEmpty, pendingID == lastTranscriptID else {
            return nil
        }
        defaults.removeObject(forKey: Key.pendingAutoInsertID)
        let text = lastTranscript.trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? nil : text
    }
}
