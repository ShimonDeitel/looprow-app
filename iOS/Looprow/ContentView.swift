import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: Project?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title.isEmpty ? "Untitled" : item.title)
                                    .font(Theme.titleFont)
                                    .foregroundStyle(.white)
                                Text("\(item.hookSize)")
                                    .font(Theme.bodyFont)
                                    .foregroundStyle(Theme.accent2)
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier("itemList")
            }
            .navigationTitle("Loop Row")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditItemView(item: nil) { newItem in
                    store.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
                EditItemView(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Project
    let onSave: (Project) -> Void
    private let isNew: Bool

    init(item: Project?, onSave: @escaping (Project) -> Void) {
        _draft = State(initialValue: item ?? Project())
        self.onSave = onSave
        self.isNew = item == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Project name", text: $draft.title)
                        .accessibilityIdentifier("field_title")
                    HStack {
                        Text("Hook size (mm)")
                        Spacer()
                        TextField("Hook size (mm)", value: $draft.hookSize, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_hookSize")
                    }
                    TextField("Yarn used", text: $draft.yarnUsed)
                        .accessibilityIdentifier("field_yarnUsed")
                    HStack {
                        Text("Row count")
                        Spacer()
                        TextField("Row count", value: $draft.rowCount, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_rowCount")
                    }
                    TextField("Pattern notes", text: $draft.patternNotes)
                        .accessibilityIdentifier("field_patternNotes")
                }
            }
            .navigationTitle(isNew ? "New Project" : "Edit Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
