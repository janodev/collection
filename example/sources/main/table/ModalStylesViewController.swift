import Collection
import UIKit

final class ModalStylesViewController: CollectionViewController
{
    convenience init() {
        let sections = [
            // the default initializer uses a HeaderModel(title: title) when title is a string
            Section(title: "UIModalPresentationStyle", rows: Self.createRows()),
        ]
        self.init(sections: sections, layout: CollectionViewLayout(style: .list))
        self.output = { [weak self] output in
            if case .clickedRow(_, let model) = output {
                (model as? ModalStyleModel).flatMap { self?.present(style: $0.style) }
            }
        }
        view.backgroundColor = .white
    }
    
    private static func createRows() -> [ModalStyleModel] {
        return [
            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none, 
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,
            
            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,

            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover
            ]
            .map { ModalStyleModel(style: $0) }
    }
    
    private func present(style: UIModalPresentationStyle)
    {
        let controller = ViewController(bgColor: .systemGray)
        controller.modalPresentationStyle = style
        controller.modalTransitionStyle = .coverVertical
        /* modalTransitionStyle may also be: .coverVertical, .flipHorizontal, .crossDissolve, .partialCurl
         The partialCurl style crashes unless modalPresentationStyle is full screen.
         */
        present(controller, animated: true, completion: nil)
    }
}

