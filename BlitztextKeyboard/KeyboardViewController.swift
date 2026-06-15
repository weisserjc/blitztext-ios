import UIKit

final class KeyboardViewController: UIInputViewController {
    private let statusLabel = UILabel()
    private let insertButton = UIButton(type: .system)
    private let dictateButton = UIButton(type: .system)
    private let nextKeyboardButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        insertPendingTranscriptIfNeeded()
        refreshStatus()
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        let titleLabel = UILabel()
        titleLabel.text = "Blitztext"
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .label

        statusLabel.font = .systemFont(ofSize: 12)
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 2

        dictateButton.setTitle("Diktieren", for: .normal)
        dictateButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        dictateButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        dictateButton.tintColor = .white
        dictateButton.backgroundColor = .systemBlue
        dictateButton.layer.cornerRadius = 14
        dictateButton.addTarget(self, action: #selector(openDictationApp), for: .touchUpInside)

        insertButton.setTitle("Letzte Ausgabe einsetzen", for: .normal)
        insertButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        insertButton.setImage(UIImage(systemName: "text.insert"), for: .normal)
        insertButton.backgroundColor = UIColor.secondarySystemBackground
        insertButton.layer.cornerRadius = 12
        insertButton.addTarget(self, action: #selector(insertLastTranscript), for: .touchUpInside)

        nextKeyboardButton.setTitle("🌐", for: .normal)
        nextKeyboardButton.titleLabel?.font = .systemFont(ofSize: 22)
        nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchUpInside)

        let header = UIStackView(arrangedSubviews: [titleLabel, UIView(), nextKeyboardButton])
        header.axis = .horizontal
        header.alignment = .center
        header.spacing = 8

        let stack = UIStackView(arrangedSubviews: [header, statusLabel, dictateButton, insertButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
            dictateButton.heightAnchor.constraint(equalToConstant: 52),
            insertButton.heightAnchor.constraint(equalToConstant: 44),
            nextKeyboardButton.widthAnchor.constraint(equalToConstant: 40),
            nextKeyboardButton.heightAnchor.constraint(equalToConstant: 36)
        ])

        refreshStatus()
    }

    private func refreshStatus() {
        let text = BlitztextSharedStore.lastTranscript
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            statusLabel.text = "Starte ein Diktat in Blitztext. Danach kann die Tastatur den Text hier einsetzen."
            insertButton.isEnabled = false
        } else {
            statusLabel.text = "Bereit: \(text.prefix(80))"
            insertButton.isEnabled = true
        }
    }

    private func insertPendingTranscriptIfNeeded() {
        guard let text = BlitztextSharedStore.consumePendingAutoInsert() else {
            return
        }
        textDocumentProxy.insertText(text)
    }

    @objc private func insertLastTranscript() {
        let text = BlitztextSharedStore.lastTranscript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        textDocumentProxy.insertText(text)
    }

    @objc private func openDictationApp() {
        guard let url = URL(string: "blitztext://record?source=keyboard") else {
            return
        }
        extensionContext?.open(url)
    }
}

