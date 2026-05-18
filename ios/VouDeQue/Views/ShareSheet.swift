import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var completion: (() -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = { _, _, _, _ in
            completion?()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
