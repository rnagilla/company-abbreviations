import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AbbreviationsViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var showSettings = false

    var categories: [String] {
        let cats = viewModel.abbreviations.compactMap { $0.category }
        return Array(Set(cats)).sorted()
    }

    var filtered: [Abbreviation] {
        viewModel.abbreviations.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.abbreviation.localizedCaseInsensitiveContains(searchText) ||
                item.fullForm.localizedCaseInsensitiveContains(searchText) ||
                (item.description?.localizedCaseInsensitiveContains(searchText) ?? false)

            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationSplitView {
            // Sidebar: category filter
            List(selection: $selectedCategory) {
                Label("All", systemImage: "square.grid.2x2")
                    .tag(String?.none)
                    .padding(.vertical, 2)

                if !categories.isEmpty {
                    Section("Categories") {
                        ForEach(categories, id: \.self) { category in
                            Label(category, systemImage: "tag")
                                .tag(Optional(category))
                                .padding(.vertical, 2)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 160)

        } detail: {
            VStack(spacing: 0) {
                // Top toolbar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search abbreviations...", text: $searchText)
                        .textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(10)
                .background(.regularMaterial)

                Divider()

                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading abbreviations...")
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        Button("Open Settings") { showSettings = true }
                            .buttonStyle(.bordered)
                    }
                    .padding()
                    Spacer()
                } else if filtered.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No abbreviations found")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else {
                    List(filtered) { item in
                        AbbreviationRow(item: item)
                    }
                    .listStyle(.inset)
                }

                // Bottom status bar
                Divider()
                HStack {
                    if let updated = viewModel.lastUpdated {
                        Text("Updated \(updated.formatted(.relative(presentation: .named)))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(filtered.count) abbreviation\(filtered.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Button {
                        Task { await viewModel.fetchAbbreviations() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .help("Refresh from GitHub")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.regularMaterial)
            }
        }
        .navigationTitle("Company Abbreviations")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "gear")
                }
                .help("Settings")
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .task {
            await viewModel.fetchAbbreviations()
        }
    }
}

struct AbbreviationRow: View {
    let item: Abbreviation

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.abbreviation)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("·")
                    .foregroundStyle(.secondary)
                Text(item.fullForm)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                if let category = item.category {
                    Text(category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }
            }
            if let desc = item.description, !desc.isEmpty {
                Text(desc)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
