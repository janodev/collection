import UIKit

public final class CollectionDataSource: NSObject, UICollectionViewDataSource
{
    var sections = [Section]()
    
    public init(sections: [Section]) {
        self.sections = sections
    }
    
    public override init() {
        sections = [Section]()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier(), for: indexPath)
        if let configurableCell = cell as? Configurable {
            configurableCell.configure(model)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let section = sections[indexPath.section]
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: section.model.reuseIdentifier(), for: indexPath) as? (UICollectionViewCell & Configurable) else {
                log.error("Couldn’t dequeue header for section.model was \(section.model)")
                return UICollectionReusableView()
            }
            cell.configure(section.model)
            return cell
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            log.error("No cell defined for footer. Section.model was \(section.model)")
            return UICollectionReusableView()
        }
        
        log.error("Couldn’t dequeue supplementary element. Section.model was \(section.model)")
        return UICollectionReusableView()
    }
}
