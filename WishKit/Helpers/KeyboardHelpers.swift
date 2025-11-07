//
//  KeyboardHelpers.swift
//  WishKit
//
//  Created by diayan siat on 07/11/2025.
//

import SwiftUI

// MARK: - Keyboard Dismiss Extension

extension View {
    /// Dismisses the keyboard when tapping outside of text fields
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Hide Keyboard Function

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
