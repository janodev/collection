import Collection
import UIKit

// Just an example, you can write your own cell from scratch as long as it conforms with `Configurable`.

class ModalStyleCell: ViewCell<ModalStyleView> {}

final class ModalStyleView: RowView
{
    override public func configure(_ model: Model) {
        guard let style = model as? ModalStyleModel else {
            log.error("Expected a ModalStyle, but got a \(model)")
            return
        }
        super.configure(RowModel(title: style.description))
    }
}
