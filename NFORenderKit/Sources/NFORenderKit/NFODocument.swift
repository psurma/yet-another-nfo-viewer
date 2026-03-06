import Foundation

public enum NFODocument {
    /// Reads a file encoded in DOS CP437 (Windows code page 437) and returns it as a Swift String.
    public static func read(url: URL) throws -> String {
        let encoding = CFStringConvertEncodingToNSStringEncoding(
            CFStringConvertWindowsCodepageToEncoding(437)
        );
        guard let content = try? String(contentsOf: url, encoding: String.Encoding(rawValue: encoding)) else {
            // Fall back to UTF-8 if CP437 fails (e.g. for plain ASCII files)
            return try String(contentsOf: url, encoding: .utf8);
        }
        return content;
    }
}
