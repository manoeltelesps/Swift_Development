//
//  EditItemView.swift
//  CrudCoreData
//
//  Created by Manoel Pedro Prado Sa Teles on 29/06/25.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var item: Item
    @State private var novaData: Date

    init(item: Item) {
        self.item = item
        _novaData = State(initialValue: item.timestamp ?? Date())
    }

    var body: some View {
        Form {
            DatePicker("Data", selection: $novaData, displayedComponents: .date)
            Button("Salvar") {
                item.timestamp = novaData
                try? viewContext.save()
                dismiss()
            }
        }
        .navigationTitle("Editar Item")
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let exemplo = Item(context: context)
    exemplo.timestamp = Date()
    
    return NavigationStack {
        EditItemView(item: exemplo)
            .environment(\.managedObjectContext, context)
    }
}
