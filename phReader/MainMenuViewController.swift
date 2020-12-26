//
//  MainMenuViewController.swift
//  phReader
//
//  Created by Gasan Akniev on 26.12.2020.
//

import UIKit

final class MainMenuViewController: UIViewController {
    // MARK: UI Components

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 2
        return stackView
    }()

    private var callbacks: [UIButton: () -> Void] = [:]

    private lazy var buttonDescriptors: [ButtonDescriptor] = [
        ButtonDescriptor(title: "Clipboard") { [weak self] in
            let vc = ClipboardTextViewerViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        },
        ButtonDescriptor(title: "Txt Files") {
            print("Txt Files")
        },
        ButtonDescriptor(title: "PDF File") {
            print("PDF File")
        },
        ButtonDescriptor(title: "Web site") {
            print("Web site")
        }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        setUpView()
        setUpStackView()
        setUpButtons()
    }

    private func setUpView() {
        view.backgroundColor = .systemBackground
    }

    private func setUpStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.center.equalToSuperview()
        }
    }

    private func setUpButtons() {
        for buttonDescriptor in buttonDescriptors {
            let button = UIButton()
            button.setTitle(buttonDescriptor.title, for: .normal)
            button.snp.makeConstraints { $0.height.equalTo(80) }
            button.addTarget(self, action: #selector(processTap(_:)), for: .touchUpInside)
            button.backgroundColor = .lightGray
            callbacks[button] = buttonDescriptor.callback
            stackView.addArrangedSubview(button)
        }
    }

    @objc private func processTap(_ button: UIButton) {
        callbacks[button]?()
    }
}

struct ButtonDescriptor {
    let title: String
    let callback: () -> Void
}