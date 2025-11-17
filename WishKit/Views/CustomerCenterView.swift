//
//  CustomerCenterView.swift
//  Wishly
//
//  Created by diayan siat on 11/11/2025.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct CustomerCenterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        NavigationStack {
            RevenueCatUI.CustomerCenterView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                }
        }
    }
}

#Preview {
    CustomerCenterView()
}
