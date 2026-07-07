import Foundation

struct Project: Identifiable, Codable, Equatable {
    let id: UUID
    var dateCreated: Date
    var title: String
    var hookSize: Double
    var yarnUsed: String
    var rowCount: Double
    var patternNotes: String

    init(id: UUID = UUID(), dateCreated: Date = Date(), title: String = "", hookSize: Double = 0, yarnUsed: String = "", rowCount: Double = 0, patternNotes: String = "") {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.hookSize = hookSize
        self.yarnUsed = yarnUsed
        self.rowCount = rowCount
        self.patternNotes = patternNotes
    }
}
