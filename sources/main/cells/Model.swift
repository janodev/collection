import UIKit

public protocol Model
{
    func reuseIdentifier() -> String
    func cell() -> (UICollectionViewCell & Configurable).Type
}

public extension Model
{
    func hash(into hasher: inout Hasher) {
        hasher.combine(reuseIdentifier())
    }
    func reuseIdentifier() -> String {
        return String(describing: type(of: self))
    }
}
