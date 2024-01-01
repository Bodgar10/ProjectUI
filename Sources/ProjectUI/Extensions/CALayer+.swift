//
//  CALayer+.swift
//  
//
//  Created by Bodgar Espinosa Miranda on 26/12/23.
//

import UIKit

extension CALayer {
    
    /// - Parameter thickness: A named line thickness
    /// - Returns: This layer with its borderWidth set to the named line thickness
    @discardableResult
    public func withBorderThickness(_ thickness: LineThickness) -> CALayer {
        borderWidth = thickness.rawValue
        return self
    }
    
    /// - Parameter namedColor: A UIColor color name
    /// - Returns: This layer with its borderColor set to the named color
    @discardableResult
    public func withBorderColor(_ namedColor: UIColor?) -> CALayer {
        borderColor = namedColor?.cgColor
        return self
    }
    
    /// - Parameter radius: A named border radius
    /// - Returns: This layer with its cornerRadius set to the named radius
    @discardableResult
    public func withCornerRadius(_ radius: BorderRadius) -> CALayer {
        cornerRadius = radius.rawValue
        return self
    }
}
