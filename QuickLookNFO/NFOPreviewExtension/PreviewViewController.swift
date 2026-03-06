import Cocoa
import QuickLookUI
import NFORenderKit

final class PreviewViewController: NSViewController, QLPreviewingController {

    override func loadView() {
        // No storyboard — build the view programmatically.
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 800, height: 600));
    }

    // MARK: - QLPreviewingController

    func preparePreviewOfFile(at url: URL) async throws {
        let content = try NFODocument.read(url: url);

        // Register fonts from the extension bundle (ATSApplicationFontsPath doesn't work in extensions).
        NFORenderer.registerFonts(in: Bundle(for: PreviewViewController.self));

        let attrStr = NFORenderer.attributedString(from: content);

        await MainActor.run {
            self.buildPreviewView(attributedString: attrStr);
        };
    }

    // MARK: - View construction

    private func buildPreviewView(attributedString attrStr: NSAttributedString) {
        let scrollView = NSScrollView();
        scrollView.hasVerticalScroller = true;
        scrollView.hasHorizontalScroller = true;
        scrollView.autohidesScrollers = true;
        scrollView.backgroundColor = .white;

        let textView = NSTextView();
        textView.isEditable = false;
        textView.isSelectable = true;
        textView.backgroundColor = .white;
        textView.drawsBackground = true;
        textView.isHorizontallyResizable = true;
        textView.isVerticallyResizable = true;
        textView.autoresizingMask = [];
        textView.textContainer?.widthTracksTextView = false;
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        );
        textView.textStorage?.setAttributedString(attrStr);

        scrollView.documentView = textView;
        scrollView.frame = self.view.bounds;
        scrollView.autoresizingMask = [.width, .height];

        self.view.subviews.forEach { $0.removeFromSuperview() };
        self.view.addSubview(scrollView);
        self.view.wantsLayer = true;
        self.view.layer?.backgroundColor = NSColor.white.cgColor;
    }
}
