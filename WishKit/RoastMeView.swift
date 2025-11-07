//
//  RoastMeView.swift
//  WishKit
//
//  Created by diayan siat on 31/10/2025.
//

import SwiftUI

struct RoastMeView: View {
    @State private var burnLevel: Double = 0.5
    @State private var roastCount: Int = 2
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {

            // Background gradient (adapts to light/dark)
            LinearGradient(
                colors: colorScheme == .dark
                ? [Color(red: 0.18, green: 0.09, blue: 0.07), Color.black]
                : [Color(red: 1.0, green: 0.72, blue: 0.68), Color(red: 0.94, green: 0.87, blue: 0.84)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with flame counter and settings
                HStack {
                    Spacer()

                    // Flame counter
                    HStack(spacing: 10) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("\(roastCount)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(colorScheme == .dark ?
                                  Color(red: 0.12, green: 0.08, blue: 0.08) :
                                  Color.white.opacity(0.85))
                            .overlay(
                                Capsule()
                                    .stroke(
                                        colorScheme == .dark
                                        ? Color(red: 0.25, green: 0.15, blue: 0.13).opacity(0.6)
                                        : Color.clear,
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                    )

                    // Settings button
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 54, height: 54)
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ?
                                          Color(red: 0.12, green: 0.08, blue: 0.08) :
                                          Color.white.opacity(0.85))
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                colorScheme == .dark
                                                ? Color(red: 0.25, green: 0.15, blue: 0.13).opacity(0.6)
                                                : Color.clear,
                                                lineWidth: 1
                                            )
                                    )
                                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                // Main content
                ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Select a Photo section
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Select a Photo")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white : .black)

                        HStack(spacing: 14) {
                            // Gallery button
                            PhotoOptionButton(
                                icon: "photo.on.rectangle.angled",
                                title: "Gallery",
                                accentColor: .purple,
                                isSelected: true,
                                colorScheme: colorScheme
                            )

                            // Camera button
                            PhotoOptionButton(
                                icon: "camera.fill",
                                title: "Camera",
                                accentColor: .orange,
                                isSelected: false,
                                colorScheme: colorScheme
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: colorScheme == .dark
                                    ? [Color(red: 0.12, green: 0.08, blue: 0.08), Color(red: 0.10, green: 0.07, blue: 0.07)]
                                    : [Color(red: 0.99, green: 0.88, blue: 0.86), Color(red: 0.97, green: 0.91, blue: 0.89)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        colorScheme == .dark
                                        ? Color(red: 0.25, green: 0.15, blue: 0.13).opacity(0.6)
                                        : Color.white.opacity(0.5),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.12), radius: 16, x: 0, y: 6)
                    )

                    // Set Burn Level section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Set Burn Level")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            Spacer()

                            HStack(spacing: 8) {
                                Image(systemName: "flame.fill")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.25))

                                Text("Hot")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }

                        // Slider
                        HStack {
                            Slider(value: $burnLevel, in: 0...1)
                                .tint(Color(red: 1.0, green: 0.5, blue: 0.35))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: colorScheme == .dark
                                    ? [Color(red: 0.12, green: 0.08, blue: 0.08), Color(red: 0.10, green: 0.07, blue: 0.07)]
                                    : [Color(red: 0.99, green: 0.88, blue: 0.86), Color(red: 0.97, green: 0.91, blue: 0.89)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        colorScheme == .dark
                                        ? Color(red: 0.25, green: 0.15, blue: 0.13).opacity(0.6)
                                        : Color.white.opacity(0.5),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.12), radius: 16, x: 0, y: 6)
                    )
                    
                    Spacer()
                    
                    // Roast Me button
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Image(systemName: "flame.fill")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("Roast Me")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(colorScheme == .dark ? Color(red: 1.0, green: 0.35, blue: 0.2) : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            Capsule()
                                .fill(colorScheme == .dark ?
                                      Color(red: 0.12, green: 0.08, blue: 0.08) :
                                      Color(red: 1.0, green: 0.42, blue: 0.32))
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            colorScheme == .dark
                                            ? Color(red: 0.25, green: 0.15, blue: 0.13).opacity(0.6)
                                            : Color.clear,
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: Color(red: 1.0, green: 0.42, blue: 0.32).opacity(0.25), radius: 16, x: 0, y: 6)
                        )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)
                }
                .padding(.top, 28)
            }
        }
    }
}

struct PhotoOptionButton: View {
    let icon: String
    let title: String
    let accentColor: Color
    let isSelected: Bool
    let colorScheme: ColorScheme

    var body: some View {
        Button(action: {}) {
            VStack(spacing: 18) {
                // Icon with glow effect
                ZStack {
                    // Glow effect for selected state
                    if isSelected {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        accentColor.opacity(colorScheme == .dark ? 0.5 : 0.4),
                                        accentColor.opacity(0.0)
                                    ]),
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: colorScheme == .dark ? 75 : 70
                                )
                            )
                            .frame(width: 140, height: 140)
                    }

                    Image(systemName: icon)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            accentColor.opacity(0.85),
                                            accentColor
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: accentColor.opacity(colorScheme == .dark ? 0.6 : 0.5), radius: colorScheme == .dark ? 18 : 14, x: 0, y: colorScheme == .dark ? 10 : 8)
                        )
                }

                Text(title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 165)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ?
                          Color(red: 0.08, green: 0.06, blue: 0.06) :
                          Color.white.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected ? accentColor.opacity(colorScheme == .dark ? 0.9 : 0.7) :
                                (colorScheme == .dark ? Color(red: 0.2, green: 0.13, blue: 0.11).opacity(0.8) : Color.white.opacity(0.3)),
                                lineWidth: isSelected ? 3 : 1.5
                            )
                    )
                    .shadow(
                        color: isSelected ? accentColor.opacity(colorScheme == .dark ? 0.5 : 0.3) : Color.black.opacity(colorScheme == .dark ? 0.4 : 0.15),
                        radius: isSelected ? 20 : 16,
                        x: 0,
                        y: isSelected ? 10 : 8
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
struct RoastMeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RoastMeView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            RoastMeView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
        }
    }
}
