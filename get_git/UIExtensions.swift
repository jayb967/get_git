//
//  UIExtensions.swift
//  get_git
//
//  Created by Rio Balderas on 4/4/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

extension UIResponder {
    //computed properties are static and var because they can be changed
    static var identifier : String {
        return String(describing: self)
    }
    
}


