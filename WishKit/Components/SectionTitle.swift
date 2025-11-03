//
//  SectionTitle.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct SectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.system(.title3, design: .rounded))
            .fontWeight(.bold)
            .foregroundStyle(.primary)
    }
}
