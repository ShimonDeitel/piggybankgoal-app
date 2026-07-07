import SwiftUI

enum Theme {
    static let background = Color(red: 0.110, green: 0.055, blue: 0.090)
    static let accent = Color(red: 0.851, green: 0.482, blue: 0.690)
    static let accent2 = Color(red: 0.561, green: 0.749, blue: 0.247)
    static let cardBackground = Color(.secondarySystemGroupedBackground)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}
