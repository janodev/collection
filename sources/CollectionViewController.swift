import AutoLayout
import UIKit

open class CollectionViewController: UIViewController, UICollectionViewDelegate
{
    var sections: [Section] {
        get { datasource.sections }
        set {
            datasource.sections = newValue
            register(sections: newValue)
        }
    }
    
    public var showHeaders: Bool = true {
        didSet {
            (collectionView.collectionViewLayout as? CollectionViewLayout)?.headerReferenceSize = showHeaders ? CGSize(width: 0, height: 54) : CGSize.zero
        }
    }
    
    public init(sections: [Section], layout: UICollectionViewLayout)
    {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.datasource = CollectionDataSource(sections: sections)
        self.collectionView = collectionView
        super.init(nibName: nil, bundle: nil)
        register(sections: sections)
    }
    
    public convenience init(sections: [Section]) {
        self.init(sections: sections, layout: CollectionViewLayout(style: .list))
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = collectionView
        view.backgroundColor = .white
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = datasource
        if isInvalidatingLayoutOnDynamicTypeChanges {
            observeDynamicFontChange()
        }
    }
    
    // MARK: - Dynamic type
    
    var isInvalidatingLayoutOnDynamicTypeChanges = true
    
    private func observeDynamicFontChange() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userChangedTextSize),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func userChangedTextSize() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Input / Output
    
    public enum Output {
        case clickedRow(indexPath: IndexPath, model: Model)
        case viewIsReady
    }
    
    public enum Input {
        case load(sections: [Section])
    }
    
    public var output: ((Output) -> Void) = { output in log.warning("Missing closure override for output \(output)") }
    
    public func input(_ input: Input) {
        switch input {
        case .load(let sections):
            log.debug("Reloading data: \(sections.count) sections")
            self.sections = sections
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private
    
    private let collectionView: UICollectionView
    private let datasource: CollectionDataSource
    
    private func register(sections: [Section])
    {
        var headers = [String: (UICollectionViewCell & Configurable).Type]()
        sections.forEach { section in
            headers[section.model.reuseIdentifier()] = section.model.cell()
        }
        headers.forEach { (key, cell) in
            log.debug("Registering header with id: \(key), cell: \(cell)")
            collectionView.register(cell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: key)
        }
        
        var rows = [String: (UICollectionViewCell & Configurable).Type]()
        sections.forEach { section in
            section.rows.forEach { row in
                rows[row.reuseIdentifier()] = row.cell()
            }
        }
        rows.forEach { (key, cell) in
            log.debug("Registering row with id: \(key), cell: \(cell)")
            collectionView.register(cell, forCellWithReuseIdentifier: key)
        }
    }

    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowModel = datasource.sections[indexPath.section].rows[indexPath.row]
        output(.clickedRow(indexPath: indexPath, model: rowModel))
        deselectItem(indexPath: indexPath)
    }
    
    /// Deselects the given index path.
    private func deselectItem(indexPath: IndexPath){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(50)) {
            if let selectedRow = self.collectionView.indexPathsForSelectedItems?.first {
                self.collectionView.deselectItem(at: selectedRow, animated: true)
            }
        }
    }
}
