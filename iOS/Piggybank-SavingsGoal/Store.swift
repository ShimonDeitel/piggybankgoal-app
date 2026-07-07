import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 20

    @Published var items: [Deposit] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("piggybank-savingsgoal_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Deposit) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Deposit) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Deposit) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Deposit].self, from: data) else {
            items = Store.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [Deposit] {
        [
        Deposit(date: Date().addingTimeInterval(-86400), goalName: "Vacation Fund", amount: "200.00", note: "Initial deposit"),
        Deposit(date: Date().addingTimeInterval(-172800), goalName: "Vacation Fund", amount: "150.00", note: "Paycheck savings"),
        Deposit(date: Date().addingTimeInterval(-259200), goalName: "Vacation Fund", amount: "75.00", note: "Birthday money")
        ]
    }
}
