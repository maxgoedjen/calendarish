import SwiftUI

extension Color {

    init?(hex: String) {
        // Loosely adapted from https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swift
        let cleaned = hex.lowercased().replacingOccurrences(of: "#", with: "")
        assert(cleaned.utf8.count == 6)
        let scanner = Scanner(string: cleaned)
        guard let rgb = scanner.scanInt32(representation: .hexadecimal) else { return nil }
        let r = Double((rgb & 0xff0000) >> 16) / 255.0
        let g = Double((rgb & 0x00ff00) >> 8) / 255.0
        let b = Double((rgb & 0x0000ff) >> 0) / 255.0
        self.init(red: r, green: g, blue: b)
    }

}
