import UIKit
import Parchment
import RxSwift
import RxCocoa

// This first thing we need to do is to create our own custom paging
// view and override the layout constraints. The default
// implementation positions the menu view above the page view
// controller, but we want to include a header view above the menu. We
// also create a layout constraint property that allows us to update
// the height of the header.

struct AdminMenuItem: PagingItem, Hashable, Comparable {
  let title: String
  let index: Int
  let badge: Int?
  
    init(title: String, index: Int, badge: Int? = nil) {
    self.title = title
    self.index = index
    self.badge = badge
  }
  
  static func <(lhs: AdminMenuItem, rhs: AdminMenuItem) -> Bool {
    return lhs.index < rhs.index
  }
}

class HeaderPagingView: PagingView {
   
  static let maxHeaderHeight: CGFloat = UIScreen.main.bounds.height
  static let minHeaderHeight: CGFloat = 120
    
    static let maxHeaderCoverWidth: CGFloat = UIScreen.main.bounds.width
    static let minHeaderCoverWidth: CGFloat = 70

  var maxHeaderHeightConstraint: NSLayoutConstraint?
    
//  var maxHeaderCoverWidthConstraint: NSLayoutConstraint?
//  var maxHeaderCoverHeightConstraint: NSLayoutConstraint?
    
    var headerView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      return view
    }()
    
//    var headerCoverView: AdminHeaderView!
    
  override func setupConstraints() {
    addSubview(headerView)
    
//    headerCoverView = AdminHeaderView()
//    headerView.addSubview(headerCoverView)

    pageView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    headerView.translatesAutoresizingMaskIntoConstraints = false
//    headerView.translatesAutoresizingMaskIntoConstraints = false

    maxHeaderHeightConstraint = headerView.heightAnchor.constraint(
      equalToConstant: HeaderPagingView.maxHeaderHeight
    )
    maxHeaderHeightConstraint?.isActive = true
    
//    maxHeaderCoverHeightConstraint = headerView.heightAnchor.constraint(
//      equalToConstant: HeaderPagingView.maxHeaderHeight
//    )
//    maxHeaderCoverHeightConstraint?.isActive = true
//
//    maxHeaderCoverWidthConstraint = headerView.widthAnchor.constraint(
//        equalToConstant: HeaderPagingView.maxHeaderCoverWidth
//    )
//    maxHeaderCoverWidthConstraint?.isActive = true
        
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight),
      collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      
      headerView.topAnchor.constraint(equalTo: topAnchor),
      headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        
//      headerView.topAnchor.constraint(equalTo: topAnchor),
//      headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//      headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      pageView.topAnchor.constraint(equalTo: topAnchor)
    ])
  }
}

// Create a custom paging view controller and override the view with
// our own custom subclass.
class HeaderPagingViewController: PagingViewController {
    
  override func loadView() {
    view = HeaderPagingView(
      options: options,
      collectionView: collectionView,
      pageView: pageViewController.view
    )
  }
}

class AdminMenuViewController: UIViewController {
  /// Cache the view controllers in an array to avoid re-creating them
  /// while swiping between pages. Since we only have three view
  /// controllers it's fine to keep them all in memory.
    let disposeBag = DisposeBag()
    
    var headerView: AdminHeaderView = {
      let view = AdminHeaderView()
      return view
    }()
    
    lazy var scrollRange: CGFloat = {
        return HeaderPagingView.maxHeaderHeight - HeaderPagingView.minHeaderHeight
    }()

    var headerScrollPercent: CGFloat = 0
    let badgeCount: Int = 12
    
    fileprivate let AdminMenuTitle = [
      "회원관리",
      "Q&A",
      "상품관리",
      "실시간구매현황"
    ]
    
  private let viewControllers = [
    TableViewController(),
    TableViewController(),
    TableViewController(),
    TableViewController()
  ]
  
  var pagingViewController = HeaderPagingViewController()
  
  private var headerConstraint: NSLayoutConstraint {
    let pagingView = pagingViewController.view as! HeaderPagingView
    return pagingView.maxHeaderHeightConstraint!
  }
    
//    private var headerCoverHeightConstraint: NSLayoutConstraint {
//      let pagingView = pagingViewController.view as! HeaderPagingView
//      return pagingView.maxHeaderCoverHeightConstraint!
//    }
//
//    private var headerCoverWidthConstraint: NSLayoutConstraint {
//      let pagingView = pagingViewController.view as! HeaderPagingView
//      return pagingView.maxHeaderCoverWidthConstraint!
//    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pagingViewController.register(AdminMenuPagingCell.self, for: AdminMenuItem.self)
    pagingViewController.menuItemSize = .fixed(width: 110, height: 48)
    pagingViewController.dataSource = self
    pagingViewController.select(pagingItem: AdminMenuItem(title: AdminMenuTitle[0], index: 0))
    
    // Customize the menu styling.
    pagingViewController.textColor = UIColor.black
    pagingViewController.selectedTextColor = UIColor(red: 230.0 / 255.0, green: 23.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    pagingViewController.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    pagingViewController.indicatorColor = UIColor(red: 230.0 / 255.0, green: 23.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    pagingViewController.borderColor = UIColor(white: 237.0 / 255.0, alpha: 1.0)
    pagingViewController.indicatorOptions = .visible(
      height: 2,
      zIndex: Int.max,
      spacing: .zero,
      insets: .zero
    )
    
    // Add the paging view controller as a child view controller.
    
    guard let pagingView = pagingViewController.view else { return }
    
    addChild(pagingViewController)
    view.addSubview(pagingView)
    pagingViewController.didMove(toParent: self)

    pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    // Set the data source for our view controllers
    pagingViewController.dataSource = self
    
    // Set our delegate so we get notified when the user swipes
    // between pages. We will use these delegates to move the
    // UIScrollViewDelegate and update the content offset.
    pagingViewController.delegate = self
    
    // Set the UIScrollViewDelegate on the initial view controller
    // so we can update the header view while scrolling.
    viewControllers.first?.tableView.delegate = self
    
    DispatchQueue.main.async() {
        self.headerConstraint.constant = HeaderPagingView.maxHeaderHeight
//        self.headerCoverHeightConstraint.constant = HeaderPagingView.maxHeaderHeight
//        self.headerCoverWidthConstraint.constant = HeaderPagingView.maxHeaderCoverWidth
        self.view.addSubview(self.headerView)
        self.headerView.contentLeadingConstraint.constant = 0
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: HeaderPagingView.maxHeaderHeight)
        
        
        
       // Contrain the paging view to all edges.
       // self.viewControllers.first?.tableView.setContentOffset(CGPoint.zero, animated: true)

        
    }
    
    self.headerView.scrollBtn.rx.tap
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            print("headerView.scrollBtn.rx.tap")
//            self.headerConstraint.constant = HeaderPagingView.minHeaderHeight
//
//            self.headerView.frame = CGRect(x: 0, y: 0, width: HeaderPagingView.maxHeaderCoverWidth, height: HeaderPagingView.minHeaderHeight)
//            self.headerView.contentLeadingConstraint.constant = self.view.bounds.width - HeaderPagingView.minHeaderCoverWidth
            
            self.viewControllers.first?.tableView.setContentOffset(CGPoint(x:0, y: -120), animated: true)
            
            
        }).disposed(by: disposeBag)
  }
}

extension AdminMenuViewController: PagingViewControllerDataSource {
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let viewController = viewControllers[index]
    viewController.title = "View \(index)"
    
    // Inset the table view with the height of the menu height.
    let height = pagingViewController.options.menuHeight + HeaderPagingView.maxHeaderHeight
    let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
    viewController.tableView.contentInset = insets
    viewController.tableView.scrollIndicatorInsets = insets
    
    return viewController
  }
  
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return AdminMenuTitle[index] == "Q&A" ? AdminMenuItem(title: AdminMenuTitle[index], index: index, badge: badgeCount) : AdminMenuItem(title: AdminMenuTitle[index], index: index)
  }
  
  func numberOfViewControllers(in: PagingViewController) -> Int{
    return viewControllers.count
  }
  
}

extension AdminMenuViewController: PagingViewControllerDelegate {
  
  func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
    guard let startingViewController = startingViewController as? TableViewController else { return }
    guard let destinationViewController = destinationViewController as? TableViewController else { return }
    
    // Set the delegate on the currently selected view so that we can
    // listen to the scroll view delegate.
    if transitionSuccessful {
      startingViewController.tableView.delegate = nil
      destinationViewController.tableView.delegate = self
    }
  }
  
  func pagingViewController(_: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
    guard let destinationViewController = destinationViewController as? TableViewController else { return }
    
    // Update the content offset based on the height of the header
    // view. This ensures that the content offset is correct if you
    // swipe to a new page while the header view is hidden.
    if let scrollView = destinationViewController.tableView {
      let offset = headerConstraint.constant + pagingViewController.options.menuHeight
      scrollView.contentOffset = CGPoint(x: 0, y: -offset)
      updateScrollIndicatorInsets(in: scrollView)
    }
  }
}

extension AdminMenuViewController: UITableViewDelegate {
  
  func updateScrollIndicatorInsets(in scrollView: UIScrollView) {
    let offset = min(0, scrollView.contentOffset.y) * -1
    let insetTop = max(pagingViewController.options.menuHeight, offset)
    let insets = UIEdgeInsets(top: insetTop, left: 0, bottom: 0, right: 0)
    
    print("insets",insets)
    scrollView.scrollIndicatorInsets = insets
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print("scrollView.contentOffset.y",scrollView.contentOffset.y)

    guard scrollView.contentOffset.y < HeaderPagingView.minHeaderHeight else {
      // Reset the header constraint in case we scrolled so fast that
      // the height was not set to zero before the content offset
      // became negative.
        if headerConstraint.constant > HeaderPagingView.minHeaderHeight {
            headerConstraint.constant = HeaderPagingView.minHeaderHeight
      }
        
      return
    }
    
    // Update the scroll indicator insets so they move alongside the
    // header view when scrolling.
    updateScrollIndicatorInsets(in: scrollView)
    
    // Update the height of the header view based on the content
    // offset of the currently selected view controller.
    
    print("headerConstraint",headerConstraint.constant, scrollRange)

    let progress: CGFloat = headerConstraint.constant - HeaderPagingView.minHeaderHeight

    headerScrollPercent = CGFloat(Float(progress/scrollRange))
    
    print("headerScrollPercent", headerScrollPercent)
    
    let openAmount = self.headerConstraint.constant - HeaderPagingView.minHeaderHeight
    let percentage = openAmount / scrollRange
    
    print("openAmount",openAmount, "percentage", percentage)
    
    let widthMax = min(HeaderPagingView.maxHeaderCoverWidth * headerScrollPercent, HeaderPagingView.maxHeaderCoverWidth)
    let width = max(HeaderPagingView.minHeaderCoverWidth, widthMax)
    
    let heightMax = min(abs(scrollView.contentOffset.y) - pagingViewController.options.menuHeight, HeaderPagingView.maxHeaderHeight)
    
    let height = max(HeaderPagingView.minHeaderHeight, heightMax)
    headerConstraint.constant = height
    
    self.headerView.frame = CGRect(x: 0 , y: 0, width: self.view.bounds.width, height: height)
    self.headerView.contentLeadingConstraint.constant = HeaderPagingView.maxHeaderCoverWidth - width
    
    self.headerView.menuView.alpha = 1.0 - headerScrollPercent
  }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating", scrollView.contentOffset.y)
        self.scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging", scrollView.contentOffset.y)
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let midPoint = HeaderPagingView.minHeaderHeight + (scrollRange / 2)

        if self.headerConstraint.constant > midPoint {
            //self.expandHeader()
           //print("expandHeader",
            print("expanded state")
        } else {
            //self.collapseHeader()
            //print("collapseHeader",
           print("collapsed state")
        }
    }
  
//    func collapseHeader() {
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.headerHeightConstraint.constant = self.minHeaderHeight
//            self.updateHeader()
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func expandHeader() {
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.headerHeightConstraint.constant = self.maxHeaderHeight
//            self.updateHeader()
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func updateHeader() {
//        let range = self.maxHeaderHeight - self.minHeaderHeight
//        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
//        let percentage = openAmount / range
//
//        self.titleTopConstraint.constant = -openAmount + 10
//        self.logoImageView.alpha = percentage
//    }
}
