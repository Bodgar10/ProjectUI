//
//  UIEdgeInsets+.swift
//  
//
//  Created by Bodgar Espinosa Miranda on 01/01/24.
//

import UIKit

extension UIEdgeInsets {
    /// Create edge insets with named spaces:
    public init(top: Spacing, left: Spacing, bottom: Spacing, right: Spacing) {
        self.init(top: top.rawValue, left: left.rawValue, bottom: bottom.rawValue, right: right.rawValue)
    }
    
    /// Create edge insets with uniform space.
    public init(uniform inset: Spacing) {
        self.init(top: inset.rawValue, left: inset.rawValue, bottom: inset.rawValue, right: inset.rawValue)
    }
    
    /// Create edge insets with uniform space:
    public init(uniform inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
}
