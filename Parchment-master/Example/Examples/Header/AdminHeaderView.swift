//
//  AdminHeaderView.swift
//  Example
//
//  Created by Inpyo Hong on 2021/02/08.
//  Copyright © 2021 Martin Rechsteiner. All rights reserved.
//

import UIKit

class AdminHeaderView: UIView {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollBtn: UIButton!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }

    func commonInit() {
      let bundle = Bundle.init(for: AdminHeaderView.self)
      if let viewsToAdd = bundle.loadNibNamed("AdminHeaderView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,
                                        .flexibleWidth]
        
        contentLeadingConstraint.constant = 0
      }
    }

}
