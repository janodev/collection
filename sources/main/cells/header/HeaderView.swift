import UIKit

public class HeaderView: UIView, Configurable
{
    let label = UILabel().configure {
        $0.font = UIFont(name: "HelveticaNeue-Medium", size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        $0.adjustsFontForContentSizeCategory = true
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
            "H:|-20-[label]-20-|",
            "H:|-20-[separator]-20-|",
            "V:|[label][separator(1)]|"
        ])
    }

    // MARK: - Configurable
    
    public func configure(_ model: Model) {
        guard let headerModel = model as? HeaderModel else {
            log.error("Expected a HeaderModel, got a \(model)")
            return
        }
        label.text = headerModel.title
    }
}
