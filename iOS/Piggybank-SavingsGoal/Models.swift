import Foundation

struct Deposit: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var goalName: String
    var amount: String
    var note: String
}
