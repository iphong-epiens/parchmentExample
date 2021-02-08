//
//  HeaderCoverView.swift
//  Example
//
//  Created by Inpyo Hong on 2021/02/08.
//  Copyright © 2021 Martin Rechsteiner. All rights reserved.
//

import UIKit

class HeaderCoverView: UIView {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var coverLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverBottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }

    func commonInit() {
      let bundle = Bundle.init(for: HeaderCoverView.self)
      if let viewsToAdd = bundle.loadNibNamed("HeaderCoverView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,
                                        .flexibleWidth]
        
        coverLeadingConstraint.constant = 0
      }
    }

}
