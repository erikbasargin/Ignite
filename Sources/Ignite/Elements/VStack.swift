//
// VStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that arranges its child elements vertically in a stack.
public struct VStack: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The spacing between elements.
    private var spacingAmount: SpacingType?

    /// The child elements contained in the stack.
    private var items: [any HTML]

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameter items: The items to use in this section.
    public init(@HTMLBuilder items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.spacingAmount = nil
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - pixels: The number of pixels between elements.
    ///   - items: The items to use in this section.
    public init(spacing pixels: Int, @HTMLBuilder items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.spacingAmount = .exact(pixels)
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The predefined size between elements.
    ///   - items: The items to use in this section.
    public init(spacing: SpacingAmount, @HTMLBuilder items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.spacingAmount = .semantic(spacing)
    }

    public func render() -> String {
        var itemAttributes = CoreAttributes()
        itemAttributes.add(classes: "mb-0")
        var items = [any HTML]()

        for item in self.items {
            switch item {
            case let container as HTMLCollection:
                for item in container.elements {
                    items.append(item.attributes(itemAttributes))
                }
            default:
                items.append(item.attributes(itemAttributes))
            }
        }

        var attributes = attributes
        attributes.add(classes: "vstack")

        if case let .exact(pixels) = spacingAmount {
            attributes.add(styles: .init(.gap, value: "\(pixels)px"))
        } else if case let .semantic(amount) = spacingAmount {
            attributes.add(classes: "gap-\(amount.rawValue)")
        }

        let content = items.map { $0.render() }.joined()
        return "<div\(attributes)>\(content)</div>"
    }
}
