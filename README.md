# Company Abbreviations — Mac App

A lightweight Mac app that displays your company's abbreviations, fetched live from a GitHub repository.

---

## Setup Guide

### Step 1: Create the GitHub Repo

1. Go to [github.com/new](https://github.com/new)
2. Name it something like `company-abbreviations`
3. Set visibility to **Public** (or Private — see note below)
4. Click **Create repository**

### Step 2: Upload abbreviations.json

1. Click **Add file → Upload files** in your new repo
2. Upload the `abbreviations.json` file included here
3. Commit the file

### Step 3: Get the Raw URL

1. Click on `abbreviations.json` in your repo
2. Click the **Raw** button (top right of the file view)
3. Copy the URL from your browser — it will look like:
   ```
   https://raw.githubusercontent.com/YOUR_ORG/company-abbreviations/main/abbreviations.json
   ```

### Step 4: Open the Mac App

1. Open the Xcode project (`CompanyAbbreviations/` folder)
2. Run the app (⌘R)
3. Click the **⚙️ gear icon** (top left) to open Settings
4. Paste your raw GitHub URL and click Save
5. The app will refresh and load your abbreviations

---

## Adding/Editing Abbreviations

Edit `abbreviations.json` directly on GitHub. Each entry looks like:

```json
{
  "id": "unique-id",
  "abbreviation": "EOD",
  "fullForm": "End of Day",
  "description": "Refers to the close of business hours",
  "category": "General"
}
```

- `id` — any unique string
- `abbreviation` — the short form (shown bold)
- `fullForm` — the expanded meaning
- `description` — optional extra context
- `category` — optional grouping (shows in sidebar)

The app refreshes from GitHub each time it launches, or when you click the ↻ button.

---

## Private Repo Note

If your repo is private, you'll need to set up a GitHub Personal Access Token and pass it as a header in the URL request. Ask your developer to update `AbbreviationsViewModel.swift` to add the `Authorization: token YOUR_TOKEN` header.

---

## Project Structure

```
CompanyAbbreviations/
├── CompanyAbbreviations/
│   ├── CompanyAbbreviationsApp.swift   # App entry point
│   ├── ContentView.swift               # Main UI with search & list
│   ├── AbbreviationsViewModel.swift    # Fetches data from GitHub
│   ├── SettingsView.swift              # GitHub URL configuration
│   └── Abbreviation.swift             # Data model
└── abbreviations.json                  # Upload this to GitHub
```
