//
//  EditItemView.swift
//  CrudSwiftData
//
//  Created by Manoel Pedro Prado Sa Teles on 29/06/25.
//

import SwiftUI
import SwiftData

struct EditItemView: View {
    @Bindable var item: Item

    var body: some View {
        Form {
            DatePicker("Data", selection: $item.timestamp)
        }
        .navigationTitle("Editar Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let exemplo = Item(timestamp: .now)
    return EditItemView(item: exemplo)
}
