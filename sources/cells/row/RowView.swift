import UIKit

public class RowView: UIView, Configurable
{
    let label = UILabel().configure {
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }
    
    let separator = UIView().configure {
        $0.backgroundColor = .lightGray
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    private func initialize()
    {
        backgroundColor = .white
        addSubview(label)
        addSubview(separator)
        al.applyVFL([
            "H:|-20-[label]-(20)-|",
            "H:|-20-[separator]-20-|",
            "V:|-[label]-[separator(1)]|"
        ])
    }

    // MARK: - Configurable

    public func configure(_ model: Model)
    {
        guard let rowModel = model as? RowModel else {
            log.error("Expected a RowModel, but got a \(model)")
            return
        }
        if let font = label.font {
            label.attributedText = NSAttributedString(string: rowModel.title, attributes: [NSAttributedString.Key.font: font])
        } else {
            label.text = rowModel.title
        }
    }
}
