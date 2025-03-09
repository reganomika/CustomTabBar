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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
