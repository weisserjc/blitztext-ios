import SwiftUI

@main
struct BlitztextiOSApp: App {
    @StateObject private var model = BlitztextDictationModel()

    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
                .onOpenURL { url in
                    guard url.scheme == "blitztext" else { return }
                    if url.host == "record" || url.path == "/record" {
                        model.startRecording()
                    }
                }
        }
    }
}
