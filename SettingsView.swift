import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("githubRawURL") private var githubRawURL: String =
        "https://raw.githubusercontent.com/YOUR_ORG/YOUR_REPO/main/abbreviations.json"

    @State private var tempURL: String = ""
    @State private var showCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title2)
                .bold()

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("GitHub Raw File URL")
                    .font(.headline)
                Text("Paste the raw URL to your abbreviations.json file on GitHub.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("https://raw.githubusercontent.com/...", text: $tempURL)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))

                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.blue)
                    Text("Go to your file on GitHub → click **Raw** → copy the URL from your browser")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .background(Color.blue.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Spacer()

            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Save") {
                    githubRawURL = tempURL
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .frame(width: 480, height: 280)
        .onAppear { tempURL = githubRawURL }
    }
}

#Preview {
    SettingsView()
}
