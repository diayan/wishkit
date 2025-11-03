//
//  SelectionGrid.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct SelectionGrid<Item: Equatable, Content: View>: View {
    let title: String
    let items: [(Item, String, String, Color)]
    @Binding var selectedItem: Item?
    let buttonBuilder: (Item, String, String, Color) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(title)

            VStack(spacing: 20) {
                ForEach(0..<2, id: \.self) { rowIndex in
                    HStack(spacing: 8) {
                        ForEach(items.indices.filter { $0 / 4 == rowIndex }, id: \.self) { index in
                            buttonBuilder(
                                items[index].0,
                                items[index].1,
                                items[index].2,
                                items[index].3
                            )
                        }

                        if rowIndex == 1 && items.count % 4 != 0 {
                            Spacer().frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .cardStyle()
    }
}
