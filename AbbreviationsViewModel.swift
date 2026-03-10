import Foundation
import SwiftUI

@MainActor
class AbbreviationsViewModel: ObservableObject {
    @Published var abbreviations: [Abbreviation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    // ⬇️ Replace this URL with your own GitHub raw file URL after setup
    private let githubRawURL = UserDefaults.standard.string(forKey: "githubRawURL")
        ?? "https://raw.githubusercontent.com/YOUR_ORG/YOUR_REPO/main/abbreviations.json"

    func fetchAbbreviations() async {
        guard let url = URL(string: githubRawURL) else {
            errorMessage = "Invalid GitHub URL. Please check Settings."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Failed to fetch data. Check your GitHub URL in Settings."
                isLoading = false
                return
            }

            let decoded = try JSONDecoder().decode([Abbreviation].self, from: data)
            abbreviations = decoded.sorted { $0.abbreviation < $1.abbreviation }
            lastUpdated = Date()
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
