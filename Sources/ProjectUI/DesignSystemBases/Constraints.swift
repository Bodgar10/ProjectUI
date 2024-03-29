//
//  Contraints.swift
//  
//
//  Created by Bodgar Espinosa Miranda on 26/12/23.
//

/// Pinning Library
///
///  Provides a method to construct LayoutContraints with a preference towards brevity
///
///  By leveraging a builder style returning self, pinning is able to be chained in a compact, functional style.
///
/// `` -> Para resaltar en el xcode


import UIKit

/// LayoutAnchorProvider doesn´t really provide a layout anchor, it is a layout anchor.
/// However, to keep this change backward compatible, use a type alias for now.
public typealias LayoutAnchor = LayoutAnchorProvider

// MARK: Base Constraints

/// Create Constraints to a LayoutAnchorProvider with attributes
///
/// By providing a list of attributes, a single pin statement can apply multiple attribute pinning to a
/// single LayoutAnchorProvider. This provides a compact form of applying simple constraints.
public extension UIView {
    @discardableResult
    /// Pins self to a LayoutAnchor.
    ///
    /// By providing a list of attributes, multiple can be applied at once between two items.
    ///
    ///- Parameters:
    ///  - attributes: List of Attributes which will be shared between `self` and `item`
    ///  - item: The `LayoutAnchor`s we wish to create `NSLayoutContraint`s to.
    ///  - relation: The relation to apply to the underlying `NSLayoutContraint`.
    ///  - spacing: The named space relative to item.
    ///  - multiplier: Rayio of how constant is applied.
    ///  - priority: `Priority` of LayoutConstraint.
    ///
    ///- Returns: `Self` ((Array of Elements) for additional pinning to be chained.
    func pin(
        _ attributes: NSLayoutConstraint.Attribute...,
        to item: LayoutAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        spacing: Spacing,
        multiplier: CGFloat = 1.0,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        for attribute in attributes {
            pin(
                attribute,
                to: item,
                relation: relation,
                constant: spacing.rawValue,
                multiplier: multiplier,
                priority: priority,
                file: file,
                line: line
            )
        }
        return self
    }
    
    @discardableResult
    /// Pins self to a LayoutAnchor.
    ///
    /// By providing a list of attributes, multiple can be applied at once between two items.
    ///
    ///- Parameters:
    ///  - attributes: List of Attributes which will be shared between `self` and `item`
    ///  - item: The `LayoutAnchor`s we wish to create `NSLayoutContraint`s to.
    ///  - relation: The relation to apply to the underlying `NSLayoutContraint`.
    ///  - constant: The constant offset relative to item.
    ///  - multiplier: Rayio of how constant is applied.
    ///  - priority: `Priority` of LayoutConstraint.
    ///
    ///- Returns: `Self` ((Array of Elements) for additional pinning to be chained.
    func pin(
        _ attributes: NSLayoutConstraint.Attribute...,
        to item: LayoutAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1.0,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        
        for attribute in attributes {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: relation,
                toItem: item,
                attribute: attribute,
                multiplier: multiplier,
                constant: constant
            )
            constraint.priority = priority
            constraint.isActive = true
            constraint.identifier = createIdentifier(attribute, file, line)
        }
        return self
    }
}

// MARK: Bulk contraints

private struct BulkAttributes {
    typealias AttributeOffsetPairs = [(NSLayoutConstraint.Attribute, CGFloat)]
    
    /// Edge attributes
    static func edges(_ insets: UIEdgeInsets) -> AttributeOffsetPairs {
        [
            (.left, insets.left),
            (.right, -insets.right),
            (.top, insets.top),
            (.bottom, -insets.bottom),
        ]
    }
    
    /// Center Attributes
    static func center(_ offset: CGPoint) -> AttributeOffsetPairs {
        [
            (.centerX, offset.x),
            (.centerY, offset.y),
        ]
    }
    
    /// Size Attributes
    static func size(_ constant: CGSize) -> AttributeOffsetPairs {
        [
            (.width, constant.width),
            (.height, constant.height),
        ]
    }
}

// MARK: Bulk constraints (Most often used group pinning)

public extension UIView {
    
    /// Pins self to `item`'s edges
    ///
    ///  - Parameters:
    ///     - item: `item` to which self is pinning.
    ///     - insets: EdgeInsets from `item` frame.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinEdges(to item: LayoutAnchor, insets: UIEdgeInsets, file: String = #file, line: Int = #line) {
        for attribute in BulkAttributes.edges(insets) {
            pin(attribute.0, to: item, constant: attribute.1, file: file, line: line)
        }
    }
    
    /// Pins self to `item`'s edges
    ///
    ///  - Parameters:
    ///     - item: `item` to which self is pinning.
    ///     - insets: Uniform inset applied to uniformly as EdgeInsets.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinEdges(to item: LayoutAnchor, inset: Spacing, file: String = #file, line: Int = #line) {
        pinEdges(to: item, insets: UIEdgeInsets(uniform: inset), file: file, line: line)
    }
    
    /// Pins self to `item`'s edges
    ///
    ///  - Parameters:
    ///     - item: `item` to which self is pinning.
    ///     - insets: Uniform inset applied to uniformly as EdgeInsets.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinEdges(to item: LayoutAnchor, inset: CGFloat, file: String = #file, line: Int = #line) {
        pinEdges(to: item, insets: UIEdgeInsets(uniform: inset), file: file, line: line)
    }
    
    /// Pins self to `item`'s edges
    ///
    ///  - Parameters:
    ///     - item: `item` to which self is pinning.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinEdges(to item: LayoutAnchor, file: String = #file, line: Int = #line) {
        pinEdges(to: item, insets: UIEdgeInsets(uniform: .zero), file: file, line: line)
    }
    
    @discardableResult
    /// Pins self to `item`'s center
    ///
    ///  - Parameters:
    ///     - item:  to which self is pinning.
    ///     - offset: CGPoint offset from center.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinCenter(to item: LayoutAnchor, offset: CGPoint ,file: String = #file, line: Int = #line) -> UIView {
        for attribute in BulkAttributes.center(offset) {
            pin(attribute.0, to: item, constant: attribute.1)
        }
        return self
    }
    
    @discardableResult
    /// Pins self to `item`'s center
    ///
    ///  - Parameters:
    ///     - item:  to which self is pinning.
    ///     - offset: uniform offset applied to uniformly as offset point.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinCenter(to item: LayoutAnchor, offset: CGFloat = 0, file: String = #file, line: Int = #line) -> UIView {
        pinCenter(to: item, offset: CGPoint(x: offset, y: offset))
    }
    
    @discardableResult
    /// Pins self to `item`'s size
    ///
    ///  - Parameters:
    ///     - item:  to which self is pinning.
    ///     - padding: Uniform size padding applied to size.
    ///     - priority: the priority assigned to the constraints.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinSize(
        to view: UIView,
        padding: CGSize,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        for attribute in BulkAttributes.size(padding) {
            pin(attribute.0, to: view, constant: attribute.1, priority: priority, file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    /// Pins self to `item`'s size
    ///
    ///  - Parameters:
    ///     - item:  to which self is pinning.
    ///     - padding: Uniform padding from view´s frame.
    ///     - priority: the priority assigned to the constraints.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinSize(
        to view: UIView,
        padding: Spacing,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        let padding = CGSize(width: padding.rawValue, height: padding.rawValue)
        return pinSize(to: view, padding: padding, priority: priority, file: file, line: line)
    }
    
    @discardableResult
    /// Pins self to `item`'s size
    ///
    ///  - Parameters:
    ///     - item:  to which self is pinning.
    ///     - padding: Uniform padding from view´s frame.
    ///     - priority: the priority assigned to the constraints.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinSize(
        to view: UIView,
        padding: CGFloat = 0,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        pinSize(to: view, padding: CGSize(width: padding, height: padding), priority: priority, file: file, line: line)
    }
    
    @discardableResult
    /// Pins self to `item`'s size
    ///
    ///  - Parameters:
    ///     - priority: the priority assigned to the constraints.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinSize(
        to constant: CGSize,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        for attribute in BulkAttributes.size(constant) {
            pin(attribute.0, constant: attribute.1, priority: priority, file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    /// Pins self to size of `constant` x `constant`
    ///
    ///  - Parameters:
    ///     - priority: the priority assigned to the constraints.
    ///  - Returns: `Self` for additional pinning to be chained.
    func pinSize(
        to constant: CGFloat,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        pinSize(to: CGSize(width: constant, height: constant), priority: priority, file: file, line: line)
    }
}

// MARK: Anchor constraints

/// Create Constraints based on an Anchor rather than LayoutAnchor
///
/// This may be useful when pinning to a heterogenous set of Providers instead of a single uniform provider. eg.
///
///  - Positive/Nevagite offsets relative to `item`
///  - When this constraint needs to have a different priority from others.
///  - When pinning to different layoutGuides vs UIView.
public extension UIView {
    
    @discardableResult
    /// Pins self to size of `xLayoutAnchor Provider`
    ///
    /// By providing a list of attributes, multiple attributes can be applied at once between two items.
    ///
    ///  - Parameters:
    ///     - location: `Attribute` which will pinned to `xAnchor`.
    ///     - item: The `xAnchor`´s we wish to create `NSLayoutConstraint`´s to.
    ///     - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///     - spacing: The named space relative to item.
    ///     - multiplier: Ratio of how constant is applied.
    ///     - priority: of `NSLayoutConstraint`.
    ///
    ///  - Returns: `Self` for additional pinning to be chained.
    func pin(
        _ location: NSLayoutConstraint.Attribute,
        to xAnchor: NSLayoutXAxisAnchor,
        spacing: Spacing,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        pin(
            location,
            to: xAnchor,
            offset: spacing.rawValue,
            relation: relation,
            priority: priority,
            file: file,
            line: line)
    }
    
    @discardableResult
    /// Pins self to size of `xLayoutAnchor Provider`
    ///
    /// By providing a list of attributes, multiple attributes can be applied at once between two items.
    ///
    ///  - Parameters:
    ///     - location: `Attribute` which will pinned to `xAnchor`.
    ///     - item: The `xAnchor`´s we wish to create `NSLayoutConstraint`´s to.
    ///     - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///     - spacing: The named space relative to item.
    ///     - multiplier: Ratio of how constant is applied.
    ///     - priority: of `NSLayoutConstraint`.
    ///
    ///  - Returns: `Self` for additional pinning to be chained.
    func pin(
        _ location: NSLayoutConstraint.Attribute,
        to xAnchor: NSLayoutXAxisAnchor,
        offset: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        let constraint = xAxisAnchor(for: location).constraint(for: relation, to: xAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        constraint.identifier = createIdentifier(location, file, line)
        return self
    }
    
    @discardableResult
    /// Pins self to size of `yLayoutAnchor Provider`
    ///
    /// By providing a list of attributes, multiple attributes can be applied at once between two items.
    ///
    ///  - Parameters:
    ///     - location: `Attribute` which will pinned to `yAnchor`.
    ///     - item: The `yLayoutAnchorProvider`´s we wish to create `NSLayoutConstraint`´s to.
    ///     - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///     - spacing: The named space relative to item.
    ///     - multiplier: Ratio of how constant is applied.
    ///     - priority: of `NSLayoutConstraint`.
    ///
    ///  - Returns: `Self` for additional pinning to be chained.
    func pin(
        _ location: NSLayoutConstraint.Attribute,
        yAnchor: NSLayoutYAxisAnchor,
        spacing: Spacing,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        pin(
            location,
            yAnchor: yAnchor,
            offset: spacing.rawValue,
            relation: relation,
            priority: priority,
            file: file,
            line: line)
    }
    
    @discardableResult
    /// Pins self to size of `yLayoutAnchor Provider`
    ///
    /// By providing a list of attributes, multiple attributes can be applied at once between two items.
    ///
    ///  - Parameters:
    ///     - location: `Attribute` which will pinned to `yAnchor`.
    ///     - item: The `yLayoutAnchorProvider`´s we wish to create `NSLayoutConstraint`´s to.
    ///     - relation: The relation to apply to the underlying `NSLayoutConstraint`.
    ///     - spacing: The named space relative to item.
    ///     - multiplier: Ratio of how constant is applied.
    ///     - priority: of `NSLayoutConstraint`.
    ///
    ///  - Returns: `Self` for additional pinning to be chained.
    func pin(
        _ location: NSLayoutConstraint.Attribute,
        yAnchor: NSLayoutYAxisAnchor,
        offset: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> UIView {
        let constraint = yAxisAnchor(for: location).constraint(for: relation, to: yAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        constraint.identifier = createIdentifier(location, file, line)
        return self
    }
    
    fileprivate func xAxisAnchor(for location: NSLayoutConstraint.Attribute) -> NSLayoutXAxisAnchor {
        translatesAutoresizingMaskIntoConstraints = false
        switch location {
        case .left:
            return leftAnchor
        case .right:
            return rightAnchor
        case .leading:
            return leadingAnchor
        case .trailing:
            return trailingAnchor
        case .centerX:
            return centerXAnchor
        default: assertionFailure("Only x-axis attributes can translate to an x-axis anchor."); return .init()
        }
    }
    
    fileprivate func yAxisAnchor(for location: NSLayoutConstraint.Attribute) -> NSLayoutYAxisAnchor {
        translatesAutoresizingMaskIntoConstraints = false
        switch location {
        case .top:
            return topAnchor
        case .bottom:
            return bottomAnchor
        case .centerY:
            return centerYAnchor
        case .firstBaseline:
            return firstBaselineAnchor
        case .lastBaseline:
            return lastBaselineAnchor
        default: assertionFailure("Only y-axis attributes can translate to an y-axis anchor."); return .init()
        }
    }
}

// MARK: Proxy Protocol which can be apply Anchor layouts to UIView or UILayoutGuide

public protocol LayoutAnchorProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

// MARK: XAxisAnchor contraints

public extension NSLayoutXAxisAnchor {
    func constraint(
        for relation: NSLayoutConstraint.Relation,
        to anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        switch relation {
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: anchor, constant: constant)
        case .equal:
            return constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: anchor, constant: constant)
        @unknown default: return constraint(equalTo: anchor, constant: constant)
        }
    }
}

// MARK: YAxisAnchor contraints

public extension NSLayoutYAxisAnchor {
    func constraint(
        for relation: NSLayoutConstraint.Relation,
        to anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        switch relation {
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: anchor, constant: constant)
        case .equal:
            return constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: anchor, constant: constant)
        @unknown default: return constraint(equalTo: anchor, constant: constant)
        }
    }
}

// MARK: Array+ConstraintExtensions

public extension Array where Element: UIView {
    @discardableResult
    ///Pins array of views to a LayoutAnchor Provider
    ///
    ///By providing a list of attributes, multiple attributes can be applied at once between two items
    ///
    ///- Parameters:
    ///  - attributes: List of Attributes which will be shared between `self` and `item`
    ///  - item: The `LayoutAnchor`s we wish to create `NSLayoutContraint`s to.
    ///  - relation: The relation to apply to the underlying `NSLayoutContraint`.
    ///  - constant: The constant offset relative to item.
    ///  - multiplier: Rayio of how constant is applied.
    ///  - priority: `Priority` of LayoutConstraint.
    ///
    ///- Returns: `Self` ((Array of Elements) for additional pinning to be chained.
    func pin(
        _ attributes: NSLayoutConstraint.Attribute...,
        to item: LayoutAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1.0,
        priority: UILayoutPriority = .required,
        file: String = #file,
        line: Int = #line
    ) -> [UIView] {
        for attribute in attributes {
            for pinView in self {
                pinView.pin(
                    attribute,
                    to: item,
                    relation: relation,
                    constant: constant,
                    multiplier: multiplier,
                    priority: priority,
                    file: file,
                    line: line
                )
            }
        }
        return self
    }
}

// MARK: NSLayoutConstraints extensions

public extension NSLayoutConstraint {

    /// - Returns: Newly created `NSLayoutContraint` constraint with modified `UILayoutPriority`
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self
        constraint.priority = priority
        return constraint
    }
}

extension UIView: LayoutAnchorProvider {}
extension UILayoutGuide: LayoutAnchorProvider {}

private func createIdentifier(
    _ attribute: NSLayoutConstraint.Attribute,
    _ file: String,
    _ line: Int) -> String?
{
    #if !DEBUG
    return nil
    #else
    let type: String
    switch attribute {
    case .left:
        type = "left"
    case .right:
        type = "right"
    case .top:
        type = "top"
    case .bottom:
        type = "bottom"
    case .leading:
        type = "leading"
    case .trailing:
        type = "trailing"
    case .width:
        type = "width"
    case .height:
        type = "height"
    case .centerX:
        type = "centerX"
    case .centerY:
        type = "centerY"
    case .lastBaseline:
        type = "lastBaseline"
    case .firstBaseline:
        type = "firstBaseline"
    case .leftMargin:
        type = "leftMargin"
    case .rightMargin:
        type = "rightMargin"
    case .topMargin:
        type = "topMargin"
    case .bottomMargin:
        type = "bottomMargin"
    case .leadingMargin:
        type = "leadingMargin"
    case .trailingMargin:
        type = "trailingMargin"
    case .centerXWithinMargins:
        type = "centerXWithinMargins"
    case .centerYWithinMargins:
        type = "centerYWithinMargins"
    case .notAnAttribute:
        type = "notAnAttribute"
    @unknown default: type = "unknownAttribute"
    }
    let name = NSString(string: NSString(string: file).lastPathComponent).deletingPathExtension
    return "\(name)-\(line)-\(type)"
    #endif
}

