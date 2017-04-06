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


extension String {
    func formatCreatedDate() -> String? {
        guard let date = self.components(separatedBy: "T").first else { return nil }
        // 2017-01-06T21:40:15Z
        
        let year = date.components(separatedBy: "-")[0]
        let month = date.components(separatedBy: "-")[1]
        let day = date.components(separatedBy: "-")[2]
        return ("\(month)-\(day)-\(year)")
    }
}
