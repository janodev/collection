import UIKit

public struct HeaderModel: Model
{
    public let title: String
    
    // MARK: - Model
    
    public func cell() -> (UICollectionViewCell & Configurable).Type {
        HeaderViewCell.self
    }
    
    public init(title: String) {
        
        self.title = title
    }
}
