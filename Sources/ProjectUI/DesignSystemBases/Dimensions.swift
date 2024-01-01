//
//  Dimensions.swift
//  
//
//  Created by Bodgar Espinosa Miranda on 26/12/23.
//

import UIKit


// MARK: Spacing

///Constants to use for spacing between elements
public struct Spacing {
    public let rawValue: CGFloat
    
    private init(_ rawValue: CGFloat) {
        self.rawValue = rawValue
    }
    
    /// Size: 0
    public static let zero = Spacing(0)
    
    /// Size: 8
    public static let small = Spacing(8)
    
    /// Size: 16
    public static let medium = Spacing(16)
    
    /// Size: 24
    public static let large = Spacing(24)
    
    /// Size: 32
    public static let xLarge = Spacing(32)
    
    /// Negates a Spacing constant
    ///
    /// - Parameter spacing: The constant to negate
    /// - Returns: The negative of the given space
    public static prefix func -(_ spacing: Spacing) -> Spacing {
        Spacing(-spacing.rawValue)
    }
}

// MARK: Line Thickness

/// Constants to use for line thickness
public enum LineThickness: CGFloat {
    case extraLight = 0.5
    case light = 1
    case medium = 2
    case heavy = 4
}

// MARK: BorderRadius

/// Constants to use for border radius
public enum BorderRadius: CGFloat {
    case extraSmall = 4
    case small = 8
    case medium = 12
    case large = 16
}
