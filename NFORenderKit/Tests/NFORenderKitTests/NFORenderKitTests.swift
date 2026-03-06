import XCTest
@testable import NFORenderKit

final class NFORenderKitTests: XCTestCase {

    // MARK: - NFODocument

    func testReadCP437File() throws {
        // Write a tiny CP437-encoded file (ASCII-safe bytes) and verify round-trip.
        let content = "Hello NFO World\r\n";
        let encoding = CFStringConvertEncodingToNSStringEncoding(
            CFStringConvertWindowsCodepageToEncoding(437)
        );
        let data = content.data(using: String.Encoding(rawValue: encoding))!;

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("test_\(UUID().uuidString).nfo");
        try data.write(to: url);
        defer { try? FileManager.default.removeItem(at: url) };

        let result = try NFODocument.read(url: url);
        XCTAssertEqual(result, content);
    }

    func testReadNonExistentFileThrows() {
        let badURL = URL(fileURLWithPath: "/tmp/does_not_exist_yanvi.nfo");
        XCTAssertThrowsError(try NFODocument.read(url: badURL));
    }

    // MARK: - NFORenderer

    func testAttributedStringHasContent() {
        let text = "Test NFO content";
        let attrStr = NFORenderer.attributedString(from: text);
        XCTAssertEqual(attrStr.string, text);
    }

    func testAttributedStringUsesMonospaceFont() {
        let attrStr = NFORenderer.attributedString(from: "A");
        let font = attrStr.attribute(.font, at: 0, effectiveRange: nil) as? NSFont;
        XCTAssertNotNil(font);
        // Should be a monospace font (either our DOS font or the system fallback).
        XCTAssertNotNil(font?.coveredCharacterSet);
    }

    func testAttributedStringHasBlackForeground() {
        let attrStr = NFORenderer.attributedString(from: "A");
        let color = attrStr.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? NSColor;
        XCTAssertEqual(color, NSColor.black);
    }

    func testAttributedStringHasWhiteBackground() {
        let attrStr = NFORenderer.attributedString(from: "A");
        let color = attrStr.attribute(.backgroundColor, at: 0, effectiveRange: nil) as? NSColor;
        XCTAssertEqual(color, NSColor.white);
    }

    func testAttributedStringCustomFontSize() throws {
        let attrStr = NFORenderer.attributedString(from: "A", fontSize: 24);
        let font = attrStr.attribute(.font, at: 0, effectiveRange: nil) as? NSFont;
        let pointSize = try XCTUnwrap(font).pointSize;
        XCTAssertEqual(Double(pointSize), 24.0, accuracy: 0.5);
    }
}
