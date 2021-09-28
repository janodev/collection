import UIKit

public struct RowModel: Model
{
    public let title: String
    
    public func cell() -> (UICollectionViewCell & Configurable).Type {
        RowViewCell.self
    }
    
    public init(title: String) {
        
        self.title = title
    }
}
