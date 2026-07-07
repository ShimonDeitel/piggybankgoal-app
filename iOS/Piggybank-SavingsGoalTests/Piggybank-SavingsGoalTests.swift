import XCTest
@testable import Piggybank-SavingsGoal

@MainActor
final class Piggybank-SavingsGoalTests: XCTestCase {
    func testSeedDataBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testFreshInstallDoesNotHitPaywall() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.items.count
        store.add(Deposit(goalName: "test-0", amount: "test-1", note: "test-2"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = Store()
        let item = Deposit(goalName: "test-0", amount: "test-1", note: "test-2")
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testCanAddMoreRespectsLimitWhenNotPro() {
        let store = Store()
        store.isPro = false
        store.items = Array(repeating: Deposit(goalName: "test-0", amount: "test-1", note: "test-2"), count: Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreAlwaysTrueWhenPro() {
        let store = Store()
        store.isPro = true
        store.items = Array(repeating: Deposit(goalName: "test-0", amount: "test-1", note: "test-2"), count: Store.freeLimit + 5)
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateModifiesExistingItem() {
        let store = Store()
        var item = Deposit(goalName: "test-0", amount: "test-1", note: "test-2")
        store.add(item)
        item.goalName = "changed"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.goalName, "changed")
    }

    func testDeleteAtOffsets() {
        let store = Store()
        store.items = []
        store.add(Deposit(goalName: "test-0", amount: "test-1", note: "test-2"))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 0)
    }
}
