import UIKit

public final class CollectionViewLayout: UICollectionViewFlowLayout
{
    public enum LayoutStyle {
        case inline
        case list
        case grid
    }
    
    public var style: LayoutStyle = .grid {
        didSet {
            if style != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    public convenience init(style: LayoutStyle)
    {
        self.init()
        self.style = style
        
        // minimum spacing to use between lines of items in the grid
        self.minimumLineSpacing = 10
        
        // Minimum spacing to use between items in the same row.
        // Careful, a value of 0 will make the cells disappear in horizontal scrolling.
        self.minimumInteritemSpacing = 10
        
        // default sizes to use for section headers
        self.headerReferenceSize = CGSize(width: 0, height: 60)
        
        // This is for cases where datasource is already set and we are switching layout
        self.configLayout()
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
    
    /// Called from invalidateLayout() when the datasource is set.
    private func configLayout()
    {
        guard let collectionView = collectionView else {
            log.debug("Collection view is nil. Skipping layout.")
            return
        }
        guard collectionView.frame.width > 0 else {
            log.warning("Collection view not prepared. It has 0 width. Skipping layout. Try setting the datasource in viewWillAppear(_:).")
            return
        }
        
        switch style {
            
        case .inline:
            scrollDirection = .horizontal
            estimatedItemSize = CGSize(width: collectionView.frame.width, height: 60)
            
        case .grid:
            scrollDirection = .vertical
            if let collectionView = self.collectionView {
                let optimisedWidth = (collectionView.frame.width - minimumInteritemSpacing) / 2
                let squareSize = CGSize(width: optimisedWidth, height: optimisedWidth)
                itemSize = squareSize
            }
            
        case .list:
            scrollDirection = .vertical
            estimatedItemSize = CGSize(width: collectionView.frame.width, height: 60)
            
        }
        log.debug("Collection view read. Layout \(style) with scrollDirection \(scrollDirection.rawValue)")
    }
}
