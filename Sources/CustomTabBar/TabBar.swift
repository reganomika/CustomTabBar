import UIKit
import SnapKit

public final class TabBar: UIView {

    public weak var delegate: TabBarViewDelegate?
    private var buttons: [TabBarView] = []
    private let configuration: TabBarConfiguration

    private lazy var tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = configuration.stackViewSpacing
        return stackView
    }()
    
    private lazy var imageView: BaseImageView = {
        let imageView = BaseImageView()
        imageView.aspectFill = true
        imageView.verticalAlignment = .top
        return imageView
    }()

    public init(configuration: TabBarConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = configuration.backgroundColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = configuration.cornerRadius
        clipsToBounds = true
        setupTabBarButtons()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabBarButtons() {
        for (index, model) in configuration.tabBarItems.enumerated() {
            let view = TabBarView()
            view.tag = index
            view.configure(model: model, font: configuration.font, unselectedColor: configuration.unselectedItemColor)
            view.add(target: self, action: #selector(tabButtonTapped(_:)))
            tabBarStackView.addArrangedSubview(view)
            buttons.append(view)
            view.snp.makeConstraints { make in
                make.width.equalTo(configuration.itemWidth)
            }
        }
        updateSelectedButton(at: 0)
    }

    private func setupLayout() {
        
        if let image = configuration.image {
            addSubview(imageView)
            imageView.image = image
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        addSubview(tabBarStackView)

        tabBarStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(configuration.stackViewTopInset)
            
            switch configuration.stackViewHorizontLayout {
            case .center:
                make.centerX.equalToSuperview()
            case .insets(let inset):
                make.left.right.equalToSuperview().inset(inset)
            }
     
            make.height.equalTo(configuration.stackViewHeight)
        }
    }

    @objc private func tabButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedIndex = sender.view?.tag else { return }
        updateSelectedButton(at: selectedIndex)
        delegate?.tabBarView(self, didSelectItemAt: selectedIndex)
    }

    private func updateSelectedButton(at index: Int) {
        for (buttonIndex, model) in configuration.tabBarItems.enumerated() {
            let view = buttons[buttonIndex]
            view.textLabel.textColor = buttonIndex == index ? configuration.selectedItemColor : configuration.unselectedItemColor
            view.smallImageView.image = buttonIndex == index ? model.image?.withTintColor(configuration.selectedItemColor) : model.image?.withTintColor(configuration.unselectedItemColor)
        }
    }
}

public extension UIView {
    
    func add(target: Any?, action: Selector) {
        let recognizer = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(recognizer)
    }
}

@IBDesignable
class BaseImageView: UIView {
    
    enum HorizontalAlignment: String {
        case left, center, right
    }
    
    enum VerticalAlignment: String {
        case top, center, bottom
    }
    
    private var theImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    @IBInspectable var image: UIImage? {
        get { return theImageView.image }
        set {
            theImageView.image = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable var hAlign: String = "center" {
        willSet {
            // Ensure user enters a valid alignment name while making it lowercase.
            if let newAlign = HorizontalAlignment(rawValue: newValue.lowercased()) {
                horizontalAlignment = newAlign
            }
        }
    }
    
    @IBInspectable var vAlign: String = "center" {
        willSet {
            // Ensure user enters a valid alignment name while making it lowercase.
            if let newAlign = VerticalAlignment(rawValue: newValue.lowercased()) {
                verticalAlignment = newAlign
            }
        }
    }
    
    @IBInspectable var aspectFill: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var horizontalAlignment: HorizontalAlignment = .center
    var verticalAlignment: VerticalAlignment = .center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    func commonInit() -> Void {
        clipsToBounds = true
        addSubview(theImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let img = theImageView.image else {
            return
        }
        
        var newRect = bounds
        
        let viewRatio = bounds.size.width / bounds.size.height
        let imgRatio = img.size.width / img.size.height
        
        // if view ratio is equal to image ratio, we can fill the frame
        if viewRatio == imgRatio {
            theImageView.frame = newRect
            return
        }
        
        // otherwise, calculate the desired frame

        var calcMode: Int = 1
        if aspectFill {
            calcMode = imgRatio > 1.0 ? 1 : 2
        } else {
            calcMode = imgRatio < 1.0 ? 1 : 2
        }

        if calcMode == 1 {
            // image is taller than wide
            let heightFactor = bounds.size.height / img.size.height
            let w = img.size.width * heightFactor
            newRect.size.width = w
            switch horizontalAlignment {
            case .center:
                newRect.origin.x = (bounds.size.width - w) * 0.5
            case .right:
                newRect.origin.x = bounds.size.width - w
            default: break  // left align - no changes needed
            }
        } else {
            // image is wider than tall
            let widthFactor = bounds.size.width / img.size.width
            let h = img.size.height * widthFactor
            newRect.size.height = h
            switch verticalAlignment {
            case .center:
                newRect.origin.y = (bounds.size.height - h) * 0.5
            case .bottom:
                newRect.origin.y = bounds.size.height - h
            default: break  // top align - no changes needed
            }
        }

        theImageView.frame = newRect
    }
}
