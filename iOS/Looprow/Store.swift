import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Project] = []
    @Published var isPro: Bool = false

    static let freeLimit = 12

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("looprow_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = [
            Project(title: "Project name 1", hookSize: 10, yarnUsed: "Yarn used 1", rowCount: 10, patternNotes: "Pattern notes 1"),
            Project(title: "Project name 2", hookSize: 13, yarnUsed: "Yarn used 2", rowCount: 13, patternNotes: "Pattern notes 2"),
            Project(title: "Project name 3", hookSize: 16, yarnUsed: "Yarn used 3", rowCount: 16, patternNotes: "Pattern notes 3")
            ]
            save()
        }
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Project) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Project) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Project) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
