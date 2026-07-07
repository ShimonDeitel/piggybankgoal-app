import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAdd = false
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var editingItem: Deposit?

    @State private var newGoalName: String = ""
    @State private var newAmount: String = ""
    @State private var newNote: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No entries yet",
                        systemImage: "leaf",
                        description: Text("Tap + to add your first entry.")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            Button {
                                editingItem = item
                                loadEdit(item)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.goalName)
                                        .font(Theme.headlineFont)
                                        .foregroundStyle(.primary)
                                    Text(item.amount + " · " + item.note)
                                        .font(Theme.captionFont)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .accessibilityIdentifier("itemRow_\(item.id.uuidString)")
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Piggybank - Savings Goal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showAdd = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAdd) {
                addSheet
            }
            .sheet(item: $editingItem) { item in
                editSheet(for: item)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("GoalName", text: $newGoalName)
                    .accessibilityIdentifier("addGoalNameField")
                TextField("Amount", text: $newAmount)
                    .accessibilityIdentifier("addAmountField")
                TextField("Note", text: $newNote)
                    .accessibilityIdentifier("addNoteField")
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAdd = false
                    }
                    .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Deposit(goalName: newGoalName, amount: newAmount, note: newNote)
                        store.add(item)
                        resetNew()
                        showAdd = false
                    }
                    .accessibilityIdentifier("addSaveButton")
                    .disabled(newGoalName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func editSheet(for item: Deposit) -> some View {
        NavigationStack {
            Form {
                TextField("GoalName", text: $editGoalName)
                    .accessibilityIdentifier("editGoalNameField")
                TextField("Amount", text: $editAmount)
                    .accessibilityIdentifier("editAmountField")
                TextField("Note", text: $editNote)
                    .accessibilityIdentifier("editNoteField")
                Button("Delete Entry", role: .destructive) {
                    store.delete(item)
                    editingItem = nil
                }
                .accessibilityIdentifier("editDeleteButton")
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        editingItem = nil
                    }
                    .accessibilityIdentifier("editCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updated = item
        updated.goalName = editGoalName
        updated.amount = editAmount
        updated.note = editNote
                        store.update(updated)
                        editingItem = nil
                    }
                    .accessibilityIdentifier("editSaveButton")
                }
            }
        }
    }

    private func resetNew() {
        newGoalName = ""
        newAmount = ""
        newNote = ""
    }

    private func loadEdit(_ item: Deposit) {
        editGoalName = item.goalName
        editAmount = item.amount
        editNote = item.note
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
