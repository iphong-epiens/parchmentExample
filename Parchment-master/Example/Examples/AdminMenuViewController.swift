//
//  AdminMenuViewController.swift
//  Example
//
//  Created by Inpyo Hong on 2021/02/07.
//  Copyright © 2021 Martin Rechsteiner. All rights reserved.
//

import UIKit
import Parchment

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


class AdminMenuViewController: UIViewController {
    let badgeCount: Int = 12
  // Let's start by creating an array of icon names that
  // we will use to generate some view controllers.
  fileprivate let AdminMenuTitle = [
    "회원관리",
    "Q&A",
    "상품관리",
    "실시간구매현황"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let pagingViewController = PagingViewController()
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
    
    // Add the paging view controller as a child view controller
    // and contrain it to all edges.
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
  }
  
}

extension AdminMenuViewController: PagingViewControllerDataSource {
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    return IconViewController(title: AdminMenuTitle[index])
  }
  
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    
    return AdminMenuTitle[index] == "Q&A" ? AdminMenuItem(title: AdminMenuTitle[index], index: index, badge: badgeCount) : AdminMenuItem(title: AdminMenuTitle[index], index: index)
  }
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return AdminMenuTitle.count
  }
  
}
