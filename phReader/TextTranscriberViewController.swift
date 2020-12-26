//
//  TextTranscriberViewController.swift
//  phReader
//
//  Created by Gasan Akniev on 25.12.2020.
//

import UIKit
import SnapKit

class TextTranscriberViewController: UIViewController {
    let textView = TextGeometryViewer()
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }

    private func setUpUI() {
        setUpTextView()
    }

    private func setUpTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.margins)
        }
        textView.font = UIFont.systemFont(ofSize: 32)
        textView.backgroundColor = .white
        textView.text = text
    }
}
