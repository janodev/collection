import UIKit

/*
 A self sizing cell with dynamic height.

 How this cell works:
 
   1. In the layout set
      ```
        scrollDirection = .vertical
        estimatedItemSize = CGSize(width: collectionView.frame.width, height: 60)
      ```
      Note that if you set estimatedItemSize = UICollectionViewFlowLayout.automaticSize,
      the layout is completely screwed.
 
   2. The view passed as generic should use Auto Layout.
      An example view could have, for instance, a label pinned to its edges.
      Common mistakes that prevent self sizing:
        - ✘ Pinning the elements to the root view instead the contentView.
        - ✘ Adding a UIStackview to the contentView, then adding elements to the stack.

   3. Add the following:
      ```
        lazy var width: NSLayoutConstraint = {
          let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
          width.isActive = true
          return width
        }()

        override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                              withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                              verticalFittingPriority: UILayoutPriority) -> CGSize {
          width.constant = bounds.size.width
          return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
        }
      ```

 This does NOT work before iOS 15:

   3. This cell then overrides preferredLayoutAttributesFitting to update the
      cell’s vertical size according to layout you set in (1). Basically this:
      ```
        layoutIfNeeded()
        layoutAttributes.frame.size.height = contentView
            .systemLayoutSizeFitting(layoutAttributes.size).height.rounded()
        return layoutAttributes
      ```
 */
open class ViewCell<C: UIView & Configurable>: UICollectionViewCell, Configurable
{
    private let cellView = C()
    
    // MARK: - Initialize
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        layout()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurable
    
    public func configure(_ model: Model) {
        cellView.configure(model)
    }
    
    // MARK: - Layout
    
    private func layout() {
        contentView.addSubview(cellView)
        cellView.al.pin()
    }

    lazy var width: NSLayoutConstraint = {
      let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
      width.isActive = true
      return width
    }()

    open override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
      width.constant = bounds.size.width
      return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
