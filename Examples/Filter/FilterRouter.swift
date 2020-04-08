//
//  FilterRouter.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/21/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit

class BaseRouter {
    weak var vc: UIViewController?
       
   init(vc: UIViewController) {
       self.vc = vc
   }
}


final class FilterRouter: BaseRouter {
   
}
