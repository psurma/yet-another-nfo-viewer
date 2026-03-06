import AppKit
import CoreText

public enum NFORenderer {
    private static let preferredFontName = "More Perfect DOS VGA";
    private static let fallbackFontName = "ProFontWindows";

    /// Registers the bundled DOS fonts so they can be used in `attributedString(from:)`.
    /// Call this once before rendering, passing the bundle that contains the .ttf files.
    public static func registerFonts(in bundle: Bundle) {
        let fontFiles = [
            "More Perfect DOS VGA",
            "ProFontWindows",
        ];
        for name in fontFiles {
            if let url = bundle.url(forResource: name, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil);
            }
        }
    }

    /// Builds an NSAttributedString styled for NFO display: DOS font, black on white.
    public static func attributedString(from content: String, fontSize: CGFloat = 16) -> NSAttributedString {
        let font = NSFont(name: preferredFontName, size: fontSize)
            ?? NSFont(name: fallbackFontName, size: fontSize)
            ?? NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular);

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.black,
            .backgroundColor: NSColor.white,
        ];

        return NSAttributedString(string: content, attributes: attributes);
    }
}
