import Foundation

struct Abbreviation: Codable, Identifiable {
    let id: String
    let abbreviation: String
    let fullForm: String
    let description: String?
    let category: String?
}
