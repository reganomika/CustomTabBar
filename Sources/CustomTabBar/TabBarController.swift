import UIKit
import SnapKit

public final class TabBarController: UIViewController {

    // MARK: - Properties

    public lazy var tabBarView: TabBar = {
        let view = TabBar(configuration: configuration)
        view.delegate = self
        return view
    }()

    private let viewControllers: [UIViewController]
    private let configuration: TabBarConfiguration
    private var currentViewController: UIViewController?

    // MARK: - Initialization

    public init(viewControllers: [UIViewController], configuration: TabBarConfiguration) {
        self.viewControllers = viewControllers
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()

        if let firstVC = viewControllers.first {
            switchToViewController(firstVC)
        }
    }

    // MARK: - Setup

    private func setupView() {
        view.addSubview(tabBarView)
    }

    private func setupConstraints() {
        tabBarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(configuration.tabBarHeight)
        }
    }

    // MARK: - View Controller Switching

    private func switchToViewController(_ newViewController: UIViewController) {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        addChild(newViewController)
        view.insertSubview(newViewController.view, belowSubview: tabBarView)
        newViewController.view.frame = view.bounds
        newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newViewController.didMove(toParent: self)

        currentViewController = newViewController
    }
}

// MARK: - TabBarViewDelegate

extension TabBarController: TabBarViewDelegate {

    public func tabBarView(_ tabBarView: TabBar, didSelectItemAt index: Int) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let selectedViewController = viewControllers[index]
        switchToViewController(selectedViewController)
    }
}
