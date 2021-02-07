import UIKit
import Parchment
import BadgeSwift

class AdminMenuPagingCell: PagingCell {
    private var options: PagingOptions?

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: .zero)
    return titleLabel
  }()
    
    lazy var badgeLabel: BadgeSwift = {
        let badge = BadgeSwift(frame: .zero)
        badge.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        badge.textColor = UIColor.white
        badge.badgeColor = UIColor(red: 230.0 / 255.0, green: 23.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
        return badge
    }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel.frame = CGRect(
      x: 0,
      y: 0,
      width: contentView.bounds.width,
        height: contentView.bounds.height)
    
    if let badgeText = badgeLabel.text, let titleText = titleLabel.text {
        let titleStrSize = titleLabel.font.textWidth(s: titleText)
        let badgeStrSize = UIFont.systemFont(ofSize: 12, weight: .medium).textWidth(s: badgeText)

        badgeLabel.frame = CGRect(
            x: contentView.center.x + titleStrSize/2,
            y: contentView.bounds.minY + 10,
            width: badgeStrSize + 10,
            height: 18)

    }
  }
  
  fileprivate func configure() {
    titleLabel.backgroundColor = .white
    titleLabel.textAlignment = .center
    
    addSubview(titleLabel)
    addSubview(badgeLabel)
  }
  
    fileprivate func updateSelectedState(selected: Bool) {
      guard let options = options else { return }
      if selected {
        titleLabel.textColor = options.selectedTextColor
        titleLabel.font = options.selectedFont
      } else {
        titleLabel.textColor = options.textColor
        titleLabel.font = options.font
      }
    }
    
  override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
    self.options = options

    let menuItem = pagingItem as! AdminMenuItem
    titleLabel.text = menuItem.title
    
    if let badgeCount = menuItem.badge {
        badgeLabel.text = "\(badgeCount)"
        badgeLabel.isHidden = false
    }
    else{
        badgeLabel.isHidden = true
    }
    
    updateSelectedState(selected: selected)
  }
  
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//      super.apply(layoutAttributes)
//      guard let options = options else { return }
//
//      if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
//        titleLabel.textColor = UIColor.interpolate(
//          from: options.textColor,
//          to: options.selectedTextColor,
//          with: attributes.progress)
//      }
//    }
}

// extension UIFont
extension UIFont {
    public func textWidth(s: String) -> CGFloat
    {
        return s.size(withAttributes: [NSAttributedString.Key.font: self]).width
    }
}
