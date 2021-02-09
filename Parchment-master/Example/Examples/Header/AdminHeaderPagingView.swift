//
//  AdminHeaderPagingView.swift
//  Example
//
//  Created by Inpyo Hong on 2021/02/09.
//  Copyright © 2021 Martin Rechsteiner. All rights reserved.
//

import UIKit
import Parchment

class AdminHeaderPagingView: PagingView {

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }

    func commonInit() {
      let bundle = Bundle.init(for: AdminHeaderPagingView.self)
      if let viewsToAdd = bundle.loadNibNamed("AdminHeaderPagingView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,
                                        .flexibleWidth]
      }
    }

}
