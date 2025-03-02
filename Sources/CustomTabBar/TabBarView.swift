import UIKit
import SnapKit
public class TabBarView: UIView {

    public let smallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    public let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [smallImageView, textLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()

    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    public func configure(model: TabBarItemModel, font: UIFont, unselectedColor: UIColor) {
        smallImageView.image = model.image?.withTintColor(unselectedColor)
        textLabel.text = model.title
        textLabel.font = font
        textLabel.textColor = unselectedColor
    }
}
