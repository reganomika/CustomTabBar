import UIKit

public enum StackViewHorizont {
    case center
    case insets(inset: CGFloat)
}

public struct TabBarConfiguration {
    public var cornerRadius: CGFloat
    public var stackViewSpacing: CGFloat
    public var stackViewTopInset: CGFloat
    public var stackViewHorizontLayout: StackViewHorizont
    public var stackViewHeight: CGFloat
    public var itemWidth: CGFloat
    public var tabBarHeight: CGFloat
    public var tabBarItems: [TabBarItemModel]
    public var selectedItemColor: UIColor
    public var unselectedItemColor: UIColor
    public var font: UIFont
    public var image: UIImage?
    public var backgroundColor: UIColor

    public init(
        cornerRadius: CGFloat = 23,
        stackViewSpacing: CGFloat = 93,
        tabBarHeight: CGFloat = 109,
        tabBarItems: [TabBarItemModel],
        selectedItemColor: UIColor = .white,
        unselectedItemColor: UIColor = .white.withAlphaComponent(0.44),
        font: UIFont = .systemFont(ofSize: 16, weight: .bold),
        image: UIImage? = nil,
        stackViewTopInset: CGFloat = 16,
        stackViewHorizontLayout: StackViewHorizont = .center,
        stackViewHeight: CGFloat = 56,
        itemWidth: CGFloat = 71,
        backgroundColor: UIColor
    ) {
        self.cornerRadius = cornerRadius
        self.stackViewSpacing = stackViewSpacing
        self.tabBarHeight = tabBarHeight
        self.tabBarItems = tabBarItems
        self.selectedItemColor = selectedItemColor
        self.unselectedItemColor = unselectedItemColor
        self.font = font
        self.image = image
        self.stackViewTopInset = stackViewTopInset
        self.stackViewHorizontLayout = stackViewHorizontLayout
        self.stackViewHeight = stackViewHeight
        self.itemWidth = itemWidth
        self.backgroundColor = backgroundColor
    }
}
