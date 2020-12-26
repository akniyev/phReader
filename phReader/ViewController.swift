//
//  ViewController.swift
//  PhReader
//
//  Created by Gasan Akniev on 09.12.2020.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let textView = UITextView()
    lazy var viewButton = UIBarButtonItem(title: "To viewer...", style: .plain, target: self, action: #selector(processTap))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }

    private func setUpUI() {
        setUpTextView()
        navigationItem.rightBarButtonItem = viewButton
    }

    private func setUpTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.margins)
        }
        textView.font = UIFont.systemFont(ofSize: 24)
    }

    @objc private func processTap() {
        let tvc = TextTranscriberViewController()
        tvc.text = textView.text
        navigationController?.pushViewController(tvc, animated: true)
    }
}
