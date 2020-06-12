import Collection
import UIKit

struct ModalStyleModel: Model, Hashable
{
    let style: UIModalPresentationStyle

    func reuseIdentifier() -> String {
        return "\(ModalStyleCell.self)"
    }

    func cell() -> (UICollectionViewCell & Configurable).Type {
        ModalStyleCell.self
    }
}

extension ModalStyleModel: CustomStringConvertible
{
    var description: String {
        switch style {
        case .automatic: return "automatic"
        case .currentContext: return "currentContext"
        case .custom: return "custom"
        case .formSheet: return "formSheet"
        case .fullScreen: return "fullScreen"
        case .none: return "none – Careful! this throws “The specified modal presentation style doesn't have a corresponding presentation controller.”"
        case .overCurrentContext: return "overCurrentContext"
        case .overFullScreen: return "overFullScreen"
        case .pageSheet: return "pageSheet"
        case .popover: return "popover"
        @unknown default:
            assertionFailure("New case \(style)")
            return "Unknown style"
        }
    }
}
